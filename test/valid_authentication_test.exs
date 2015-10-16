defmodule Blackbook.AuthTest do
  use ExUnit.Case

  setup do
    Blackbook.Repo.delete_all(Blackbook.UserLog)
    Blackbook.Repo.delete_all(Blackbook.Login)
    Blackbook.Repo.delete_all(Blackbook.User)
    {:ok, user} = Blackbook.Commands.register_user(%{email: "bob@test.com", password: "password", password_confirmation: "password"})

    case Blackbook.Commands.authenticate_user(email: "bob@test.com", password: "password", ip: "127.0.0.1") do
      {:ok, user} -> {:ok, [user: user]}
      {:error, err} -> raise err
    end
  end

  test "login succeeds with valid email and password", %{user: user} do
    assert user.email == "bob@test.com"
  end

  test "it fails with bad email" do
    case Blackbook.Commands.authenticate_user(email: "adsasd@test.com", password: "password", ip: "127.0.0.1") do
      {:ok, user} -> flunk "Should not have worked"
      {:error, err} -> assert err
    end
  end
  
  test "it fails with bad password" do
    case Blackbook.Commands.authenticate_user(email: "bob@test.com", password: "adsas", ip: "127.0.0.1") do
      {:ok, user} -> flunk "Should not have worked"
      {:error, err} -> assert err
    end
  end

  test "reminder token gets set successfully", %{user: user} do
    case Blackbook.Commands.reset_reminder_token(user) do
      {:ok, token} -> assert token
      {:error, err} -> flunk "Failure"
    end
  end
end
