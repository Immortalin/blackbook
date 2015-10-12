defmodule Blackbook.Registration do

  alias Blackbook.User
  alias Blackbook.UserLog
  alias Blackbook.Login
  alias Blackbook.Repo


  @doc """
  Registers a user, creating a log, auth-token login and a bcrypt hashed password.

  ## Examples

  ```
  {:ok, user} = Blackbook.Regstration.submit_application [email: 'test@test.com', password: 'password', confirm: 'password']
  ```

  """
  def submit_application(creds) do

    validate_passwords({:ok, creds})
      |> validate_email
      |> ensure_email_doesnt_exist
      |> Blackbook.Util.hash_password
      |> add_to_database

  end


  # ==================================================================================== Privvies

  defp validate_passwords({:error, err}), do: {:error, err}
  defp validate_passwords({:ok, creds}) do
    {_, password, confirm} = creds
    case password === confirm do
      true -> {:ok, creds}
      false -> {:error,  "Password and confirm do not match"}
    end
  end

  defp validate_email({:error, err}), do: {:error, err}
  defp validate_email({:ok, creds}) do
    {email, _, _} = creds
    #make sure it's at least 6 chars long with an "@" and a "."
    cond do
      String.length(email) >= 6 && String.contains?(email, "@") && String.contains?(email, ".") ->
        {:ok, creds}
      true ->
        {:error,  "Email appears to be invalid"}
    end
  end

  defp ensure_email_doesnt_exist({:error, err}), do: {:error, err}
  defp ensure_email_doesnt_exist({:ok, creds}) do
    {email, _, _} = creds
    existing = User.find_by_email(email)
    if existing do
      {:error, "This email already exists in our system"}
    else
      {:ok, creds}
    end
  end


  defp add_to_database({:error, err}) do
    {:error, err}
  end

  defp add_to_database({:ok, creds}) do
    {email, hashed} = creds
    #within a transaction, add the record, add two logins, log it
    Repo.transaction fn ->

      #create the user record
      {:ok, new_user} = Repo.insert(%User{email: email})

      #add a login
      Repo.insert %Login{user_id: new_user.id, provider_key: email, provider_token: hashed}
      Repo.insert %Login{user_id: new_user.id, provider_key: "token", provider_token: Ecto.UUID.generate(), provider: "token"}

      #log it
      Repo.insert %UserLog{user_id: new_user.id, subject: "Registration", entry: "New registration for #{email}"}

      new_user
    end

  end



end
