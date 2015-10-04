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

  test "changing password to an invalid password fails"  do
    case Blackbook.Authentication.change_password("test@test.com", "password", "poop") do
      {:ok, res} -> flunk "Nope this should not work"
      {:error, err} -> assert err
    end
  end
  test "changing password for a non-existent email fails"  do
    case Blackbook.Authentication.change_password("asdasdasd@test.com", "password", "password") do
      {:ok, res} -> flunk "Nope this should not work"
      {:error, err} -> IO.inspect err; assert err
    end
  end

  test "resetting reminder succeeds with valid email" do
    case Blackbook.Authentication.get_reminder_token("test@test.com") do
      {:ok, token} -> assert token
      {:error, err} -> flunk err
    end
  end

  test "validating a password reset with expiration in future succeeds" do
    {:ok,token} = Blackbook.Authentication.get_reminder_token("test@test.com")
    case Blackbook.Authentication.validate_password_reset(token) do
      {:ok, token} -> assert token
      {:error, err} -> flunk err
    end
  end

  test "validating a password reset with expired token fails", %{res: auth_res} do
    change = Blackbook.User.changeset(auth_res, %{password_reset_token_expiration: nil })
    Blackbook.Repo.update(change)
    case Blackbook.Authentication.validate_password_reset(auth_res.password_reset_token) do
      {:ok, token} ->  flunk "This should not work"
      {:error, err} -> assert err
    end
  end

end
