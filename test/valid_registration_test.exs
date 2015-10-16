defmodule Blackbook.ValidRegistrationTest do

  use ExUnit.Case
  import Ecto.Query

  setup do

    Blackbook.Repo.delete_all Blackbook.Login
    Blackbook.Repo.delete_all Blackbook.UserLog
    Blackbook.Repo.delete_all Blackbook.User

    case Blackbook.Commands.register_user(%{email: "test@test.com", password: "password", password_confirmation: "password"})  do
      {:ok, user} -> {:ok, user: user}
      {:error, change} -> raise IO.inspect change.errors
    end
  end


  test "it is successful", %{user: user} do
    assert user.id
  end

  test "two logins are created", %{user: user} do
    logins = Blackbook.Repo.all from l in Blackbook.Login
    assert length(logins) == 2
  end

  test "a log created", %{user: user} do
    logs = Blackbook.Repo.all from l in Blackbook.UserLog
    assert length(logs) == 1
  end

  test "changing passwords works with valid new password", %{user: user} do
    case Blackbook.Commands.change_password(user.email, "password", "new_password") do
      {:ok, res} -> assert user.id == res.id
      {:error, err} -> flunk "Didn't work"
    end
  end

  test "changing passwords fails with valid wrong old password", %{user: user} do
    case Blackbook.Commands.change_password(user.email, "paasdadsssword", "new_password") do
      {:ok, res} -> flunk "Should not have worked"
      {:error, err} -> assert err
    end
  end

end
