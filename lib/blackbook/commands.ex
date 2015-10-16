defmodule Blackbook.Commands do
  alias Blackbook.Repo
  alias Blackbook.User
  alias Blackbook.UserLog
  alias Blackbook.Login

  use Timex

  import Blackbook.Queries
  import Comeonin.Bcrypt, only: [checkpw: 2]

  def register_user(params) do
   params = Map.put_new(params, :ip, "127.0.0.1")
   #create a changeset with the params
   change = User.registration_changeset(%User{}, params)

   if change.valid? do
     Repo.transaction fn ->
       #add the user
       case Repo.insert change do
          {:ok, new_user} ->
              generate_logins(new_user, change.changes.password_hash)
              |> log_it("Registration", "New registration for #{new_user.email}", params.ip)

          {:error, changeset} -> {:error, changeset.errors}
       end
     end
   else
     {:error, change.errors}
   end
  end

  def authenticate_user([provider: provider, provider_token: provider_token, provider_key: provider_key, ip: ip]) do
    login = get_login(provider: provider,  provider_token: provider_token, provider_key: provider_key)
    cond do
      login -> accept_login(login, ip)
      true -> {:error, "This login doesn't exist in our system"}
    end
  end

  def authenticate_user([token: token, ip: ip]) do
    login = get_login(provider: "token", provider_key: "token", provider_token: token)
    cond do
      login -> accept_login(login, ip)
      true -> {:error, "This login doesn't exist in our system"}
    end
  end


  def authenticate_user([email: email, password: password]),
    do: authenticate_user email: email, password: password, ip: "127.0.0.1"

  def authenticate_user([email: email, password: password, ip: ip]) do

    login = get_login(provider: "local", provider_key: email)

    cond do
      login && checkpw(password, login.provider_token) -> accept_login(login, ip)
      login -> {:error, "That password is incorrect"}
      true -> {:error, "This login doesn't exist in our system"}
    end

  end

  def change_password(email, old_password, new_password, ip \\ "127.0.01") do
    login = Blackbook.Queries.get_login(provider_key: email, provider: "local")

    cond do
      login && checkpw(old_password, login.provider_token) -> reset_password(login, new_password, ip)
      true -> {:error, "This login does not exist in our system"}
    end

  end


  def suspend(email, reason) do
    change_status email, "suspended", reason
  end

  def ban(email, reason) do
    change_status email, "banned", reason
  end

  def activate(email, reason) do
    change_status email, "active", reason
  end

  def reset_reminder_token(user) do

    new_token = SecureRandom.urlsafe_base64()
    expiration = Date.now |> Date.add(Time.to_timestamp(1, :days))

    changeset = Blackbook.User.changeset(user,%{password_reset_token: new_token, password_reset_token_expiration: expiration })

    case Repo.update changeset do
      {:ok, user} -> {:ok, user.password_reset_token}
      {:error, err} -> {:error, err}
    end
  end


  defp reset_password(login, new_password, ip) do
    user = Blackbook.Queries.get_user(id: login.user_id)
    change = User.registration_changeset(user, %{password: new_password, password_confirmation: new_password})

    if change.valid? do
      Repo.update!(change)
        |> log_it("Authentication", "User changed password", ip)
      {:ok, user}
    else
      {:error, change.errors}
    end

  end

  defp change_status(email, status, reason) do
    user = Blackbook.Queries.get_user(email: email)
    cond do
      user ->
        change = User.changeset(user, %{status: status})
        Blackbook.Repo.update!(change)
          |> log_it("Authentication", "Status changed to #{status} because #{reason}", "--")

        #pull the user record back out
        {:ok, Blackbook.Queries.get_user(email: email)}

      true -> {:error, "This user doesn't exist"}
    end
  end


  defp accept_login(login, ip) do
    res = get_user(id: login.user_id)
      |> ensure_status
      |> create_session
      |> update_stats
      |> log_it("Authentication", "logged in", ip)

    case res do
      {:error, err} -> {:error, err}
      user -> {:ok, user}
    end
  end

  defp update_stats({:error, err}), do: {:error, err}
  defp update_stats(user) do
    change = User.changeset(user, %{last_login: Ecto.DateTime.local})
    Repo.update change
    user
  end

  defp ensure_status({:error, err}), do: {:error, err}
  defp ensure_status(user) do
    cond do
      user.status == "active" -> user
      true -> {:error, "This account is currently #{user.status}"}
    end
  end

  defp create_session({:error, err}), do: {:error, err}
  defp create_session(user) do

    user
  end

  defp log_it({:error, err}, _, _, _), do: {:error, err}
  defp log_it(user, subject, entry, ip) do

    %UserLog{
      user_id: user.id,
      subject: subject,
      entry: entry,
      ip: ip
    } |> Repo.insert

    user
  end

  defp generate_logins(new_user, hashed_password) do
    %Login{user_id: new_user.id, provider_key: new_user.email, provider_token: hashed_password, provider: "local"}
     |> Repo.insert

    %Login{user_id: new_user.id, provider_key: "token",  provider_token: Ecto.UUID.generate(), provider: "token"}
     |> Repo.insert
    new_user
  end


end
