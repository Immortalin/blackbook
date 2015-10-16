defmodule Blackbook.InvalidAuthenticationTest do
  use ExUnit.Case

  setup do
    Blackbook.Repo.delete_all(Blackbook.UserLog)
    Blackbook.Repo.delete_all(Blackbook.Login)
    Blackbook.Repo.delete_all(Blackbook.User)
    {:ok, user} = Blackbook.Commands.register_user(%{email: "bill@test.com", password: "password", password_confirmation: "password"})
    {:ok, user: user}
  end

  test "invalid password returns error" do
    case Blackbook.Commands.authenticate_user(email: "bill@test.com", password: "poop") do
      {:ok, _} -> flunk "Let in with bad password!"
      {:error, err} -> assert err == "That password is incorrect"
    end
  end

  test "invalid email returns error" do
    case Blackbook.Commands.authenticate_user(email: "jimmu@test.com", password: "poop") do
      {:ok, _} -> flunk "Let in with bad email!"
      {:error, err} -> assert err == "This login doesn't exist in our system"
    end
  end

  test "status not active returns error", %{user: user} do
    change = Blackbook.User.changeset(user, %{status: "suspended"})
    Blackbook.Repo.update! change
    case Blackbook.Commands.authenticate_user(email: "bill@test.com", password: "password") do
      {:ok, _} -> flunk "Let in with bad status!"
      {:error, err} -> assert err == "This account is currently suspended"
    end
  end

end
