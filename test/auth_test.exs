defmodule Blackbook.AuthTest do
  use ExUnit.Case

  setup do

    #delete the users if they are there
    Blackbook.Repo.delete_all(Blackbook.Login)
    Blackbook.Repo.delete_all(Blackbook.UserLog)
    Blackbook.Repo.delete_all(Blackbook.User)

    Blackbook.Registration.submit_application({"test@test.com", "password", "password"})
    case Blackbook.Authentication.authenticate_by_email_password("test@test.com", "password") do
      {:ok, auth_res} -> {:ok, [res: auth_res]}
      {:error, err} -> raise err
    end
  end

  test "valid credentials is successful", %{res: auth_res} do
    assert auth_res.id
  end

  test "invalid credentials fails" do
    case Blackbook.Authentication.authenticate_by_email_password("test@test.com", "passzxfsdword") do
      {:ok, _} -> flunk "You messed up son"
      {:error, err} -> assert err == "That password is invalid"
    end
  end

  test "invalid email fails" do
    case Blackbook.Authentication.authenticate_by_email_password("test@tesdfdst.com", "password") do
      {:ok, _} -> flunk "You messed up son"
      {:error, err} -> assert err == "This email doesn't exist in our system"
    end
  end

  test "logging in with token is successful", %{res: auth_res} do
    login = Blackbook.Repo.get_by(Blackbook.Login, [user_id: auth_res.id, provider: "token"])
    case Blackbook.Authentication.authenticate_by_token(login.provider_token) do
      {:ok, user} -> assert user.id
      {:error, _} -> flunk "You messed up son"
    end
  end

  test "logging in when status isn't active fails" do
    user = Blackbook.User.find_by_email("test@test.com")
    changeset = Blackbook.User.changeset(user, %{status: "banned"})
    Blackbook.Repo.update(changeset)
    case Blackbook.Authentication.authenticate_by_email_password("test@test.com", "password") do
      {:ok, _} -> flunk "You messed up son"
      {:error, err} -> assert err == "This account is currently denied access"
    end

  end

  test "changing password to a new valid password"  do
    case Blackbook.Authentication.change_password("test@test.com", "password", "another_password") do
      {:ok, res} -> assert res
      {:error, err} -> flunk err
    end
  end

end
