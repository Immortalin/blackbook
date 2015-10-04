defmodule Blackbook.Authentication do



  def authenticate_by_token(token) do
    login = Blackbook.Repo.get_by(Blackbook.Login, provider_key: "token", provider: "token", provider_token: token)
    case login do
      nil -> {:error, "That token is invalid"}
      login -> pull_user_record({:ok, login})
              |> ensure_status_allows_login
              |> log_it
    end
  end

  def authenticate_by_email_password(email, password) do
    locate_login_by_email(email)
      |> verify_password(password)
      |> pull_user_record
      |> ensure_status_allows_login
      |> log_it
  end


  def change_password(email, old_password, new_password) do
    locate_login_by_email(email)
      |> verify_password(old_password)
      |> reset_password(new_password)
  end

  # ===================================================================================== Privvies

  defp reset_password({:ok, login}, new_password) do
    case Blackbook.Util.hash_password new_password do
      {:ok, hashed} ->
        changeset = Blackbook.Login.changeset(login, %{provider_token: hashed})
        Blackbook.Repo.update changeset

      {:error, err} -> {:error, err}
    end
  end

  defp locate_login_by_email(email) do
    #get the user
    case Blackbook.User.find_login(email) do
      nil -> {:error, "This email doesn't exist in our system"}
      login -> {:ok, login}
    end
  end

  defp verify_password({:error, err}, password), do: {:error, err}
  defp verify_password({:ok, login}, password) do
    case Comeonin.Bcrypt.checkpw(password, login.provider_token) do
      true -> {:ok, login}
      false -> {:error, "That password is invalid"}
    end
  end

  defp pull_user_record({:error, err}), do: {:error, err}
  defp pull_user_record({:ok, login}) do
    {:ok, Blackbook.Repo.get(Blackbook.User, login.user_id)}
  end

  defp ensure_status_allows_login({:error, err}), do: {:error, err}
  defp ensure_status_allows_login({:ok, user}) do
    case user.status do
      "active" -> {:ok, user}
      _ -> {:error, "This account is currently denied access"}
    end
  end

  defp log_it({:error, err}), do: {:error, err}
  defp log_it({:ok, user}) do
    Blackbook.Repo.transaction fn ->
      #add a log entry
      Blackbook.Repo.insert %Blackbook.UserLog{user_id: user.id, subject: "Authentication", entry: "User #{user.email} logged in"}

      #set the last login
      changeset =Blackbook.User.changeset(user, %{last_login: Ecto.DateTime.local()})
      {:ok, user} = Blackbook.Repo.update changeset
      user
    end
  end

end