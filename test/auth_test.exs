defmodule BlackBook.AuthTest do
  use ExUnit.Case

  setup do

    #delete the users if they are there
    BlackBook.Repo.delete_all(BlackBook.Login)
    BlackBook.Repo.delete_all(BlackBook.UserLog)
    BlackBook.Repo.delete_all(BlackBook.User)

    BlackBook.Registration.submit_application({"test@test.com", "password", "password"})
    case BlackBook.Authentication.authenticate_by_email_password([email: "test@test.com", password: "password"]) do
      {:ok, auth_res} -> {:ok, [res: auth_res]}
      {:error, err} -> raise err
    end
  end

  test "valid credentials is successful", %{res: auth_res} do
    assert auth_res.id
  end

  test "invalid credentials fails" do
    case BlackBook.Authentication.authenticate_by_email_password([email: "test@test.com", password: "sdfsdf"]) do
      {:ok, _} -> flunk "You messed up son"
      {:error, err} -> assert err == "That password is invalid"
    end
  end

  test "invalid email fails" do
    case BlackBook.Authentication.authenticate_by_email_password([email: "adsasdasdasd", password: "password"]) do
      {:ok, _} -> flunk "You messed up son"
      {:error, err} -> assert err == "This email doesn't exist in our system"
    end
  end

  test "logging in with token is successful", %{res: auth_res} do
    login = BlackBook.Repo.get_by(BlackBook.Login, [user_id: auth_res.id, provider: "token"])
    case BlackBook.Authentication.authenticate_by_token(login.provider_token) do
      {:ok, user} -> assert user.id
      {:error, err} -> flunk "You messed up son"
    end
  end

  test "logging in when status isn't active fails" do
    user = BlackBook.User.find_by_email("test@test.com")
    changeset = BlackBook.User.changeset(user, %{status: "banned"})
    BlackBook.Repo.update(changeset)
    case BlackBook.Authentication.authenticate_by_email_password([email: "test@test.com", password: "password"]) do
      {:ok, _} -> flunk "You messed up son"
      {:error, err} -> assert err == "This account is currently denied access"
    end

  end
end
