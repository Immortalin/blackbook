defmodule BlackBook.Registration do

  import Ecto.Query

  alias BlackBook.User
  alias BlackBook.UserLog
  alias BlackBook.Login
  alias BlackBook.Repo

  def validate_passwords({:error, err}), do: {:error, err}
  def validate_passwords({:ok, creds}) do
    {_, password, confirm} = creds
    case password === confirm do
      true -> {:ok, creds}
      false -> {:error,  "Password and confirm do not match"}
    end
  end

  def validate_email({:error, err}), do: {:error, err}
  def validate_email({:ok, creds}) do
    {email, _, _} = creds
    #make sure it's at least 6 chars long with an "@" and a "."
    cond do
      String.length(email) >= 6 && String.contains?(email, "@") && String.contains?(email, ".") ->
        {:ok, creds}
      true ->
        {:error,  "Email appears to be invalid"}
    end
  end

  def ensure_email_doesnt_exist({:error, err}), do: {:error, err}
  def ensure_email_doesnt_exist({:ok, creds}) do
    {email, _, _} = creds
    existing = User.find_by_email(email)
    if existing do
      {:error, "This email already exists in our system"}
    else
      {:ok, creds}
    end
  end

  def hash_password({:error, err}) do
    {:error, err}
  end

  def hash_password({:ok, creds}) do
    {email, password, _} = creds
    #reset these if you want stronger password checks
    case Comeonin.create_hash(password, [min_length: 6, extra_chars: false, common: false]) do
      {:ok, hashed} -> {:ok, {email, hashed}}
      {:error, err} -> {:error, err}
    end
  end

  def add_to_database({:error, err}) do
    {:error, err}
  end

  def add_to_database({:ok, creds}) do
    {email, hashed} = creds
    #within a transaction, add the record, add two logins, log it
    db_changes = Repo.transaction fn ->

      #create the user record
      {:ok, new_user} = Repo.insert(%User{email: email})

      #add a login
      new_login = Repo.insert %Login{user_id: new_user.id, provider_key: email, provider_token: hashed}
      token_login = Repo.insert %Login{user_id: new_user.id, provider_key: "token", provider_token: Ecto.UUID.generate(), provider: "token"}

      #log it
      Repo.insert %UserLog{user_id: new_user.id, subject: "Registration", entry: "New registration for #{email}"}

      new_user
    end

  end

  def submit_application(creds) do

    reg_result = validate_passwords({:ok, creds})
      |> validate_passwords
      |> validate_email
      |> ensure_email_doesnt_exist
      |> hash_password
      |> add_to_database

  end

end
