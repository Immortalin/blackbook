defmodule Blackbook.StatusTest do
  use ExUnit.Case
  alias Blackbook.User

  setup do
    Blackbook.Repo.delete_all(Blackbook.Login)
    Blackbook.Repo.delete_all(Blackbook.UserLog)
    Blackbook.Repo.delete_all(Blackbook.User)
    case Blackbook.Registration.submit_application({"bob@test.com", "password", "password"}) do
      {:ok, user} -> {:ok, [user: user]}
      {:error, err} -> raise err
    end
  end

  test "suspending user succeeds", %{user: user} do

    case User.suspend("bob@test.com", "This is a test") do
      {:ok, user} -> assert user.status == "suspended"
      {:error, err} -> flunk err
    end

  end

  test "suspending user succeeds", %{user: user} do

    case User.suspend("bob@test.com", "This is a test") do
      {:ok, user} -> assert user.status == "suspended"
      {:error, err} -> flunk err
    end

  end

  test "activating user succeeds", %{user: user} do

    case User.activate("bob@test.com", "This is a test") do
      {:ok, user} -> assert user.status == "active"
      {:error, err} -> flunk err
    end

  end
end
