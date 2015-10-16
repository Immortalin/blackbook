defmodule Blackbook.StatusTest do
  use ExUnit.Case
  alias Blackbook.User

  setup do
    Blackbook.Repo.delete_all(Blackbook.Login)
    Blackbook.Repo.delete_all(Blackbook.UserLog)
    Blackbook.Repo.delete_all(Blackbook.User)
    {:ok, user} = Blackbook.Commands.register_user(%{email: "joe@test.com", password: "password", password_confirmation: "password"})
    {:ok, user: user}
  end

  test "suspending user succeeds", %{user: user} do

    case Blackbook.Commands.suspend(user.email, "This is a test") do
      {:ok, user} -> assert user.status == "suspended"
      {:error, err} -> flunk err
    end

  end

  test "banning user succeeds", %{user: user} do

    case Blackbook.Commands.ban(user.email, "This is a test") do
      {:ok, user} -> assert user.status == "banned"
      {:error, err} -> flunk err
    end

  end

  test "activating user succeeds", %{user: user} do

    case Blackbook.Commands.activate(user.email, "This is a test") do
      {:ok, user} -> assert user.status == "active"
      {:error, err} -> flunk err
    end

  end
end
