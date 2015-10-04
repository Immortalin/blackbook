defmodule BlackBook.Authentication do


  def locate_login(creds) do
    email = Keyword.get(creds, :email)

    #get the user
    case BlackBook.User.find_login(email) do
      nil -> {:error, "This email doesn't exist in our system"}
      login -> {:ok, {login, creds}}
    end
  end

  def verify_password({:error, err}), do: {:error, err}
  def verify_password({:ok, {login, creds}}) do
    password = Keyword.get(creds, :password)
    case Comeonin.Bcrypt.checkpw(password, login.provider_token) do
      true -> {:ok, login}
      false -> {:error, "That password is invalid"}
    end
  end

  def pull_user_record({:error, err}), do: {:error, err}
  def pull_user_record({:ok, login}) do
    {:ok, BlackBook.Repo.get(BlackBook.User, login.user_id)}
  end

  def ensure_status_allows_login({:error, err}), do: {:error, err}
  def ensure_status_allows_login({:ok, user}) do
    case user.status do
      "active" -> {:ok, user}
      _ -> {:error, "This account is currently denied access"}
    end
  end

  def log_it({:error, err}), do: {:error, err}
  def log_it({:ok, user}) do
    BlackBook.Repo.transaction fn ->
      #add a log entry
      BlackBook.Repo.insert %BlackBook.UserLog{user_id: user.id, subject: "Authentication", entry: "User #{user.email} logged in"}

      #set the last login
      changeset =BlackBook.User.changeset(user, %{last_login: Ecto.DateTime.local()})
      {:ok, user} = BlackBook.Repo.update changeset
      user
    end
  end

  def authenticate_by_token(token) do
    login = BlackBook.Repo.get_by(BlackBook.Login, provider_key: "token", provider: "token", provider_token: token)
    case login do
      nil -> {:error, "That token is invalid"}
      login -> pull_user_record({:ok, login})
              |> ensure_status_allows_login
              |> log_it
    end
  end

  def authenticate_by_email_password(creds) do
    locate_login(creds)
      |> verify_password
      |> pull_user_record
      |> ensure_status_allows_login
      |> log_it
  end

end
