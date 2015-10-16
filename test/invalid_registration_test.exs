defmodule Blackbook.InvalidRegistrationTest do

  use ExUnit.Case
  import Ecto.Query

  test "mismatched passwords fail" do
    case Blackbook.Commands.register_user(%{email: "test@test.com", password: "password", password_confirmation: "asdasd"})  do
      {:ok, user} -> flunk "User was registered with bad passwords"
      {:error, errors} -> assert errors
    end
  end

  test "too short password fails" do
    case Blackbook.Commands.register_user(%{email: "test@test.com", password: "sd", password_confirmation: "sd"})  do
      {:ok, user} -> flunk "User was registered with bad passwords"
      {:error, errors} -> assert errors
    end
  end

  test "email without @ and . fails" do
    case Blackbook.Commands.register_user(%{email: "sdfsdf", password: "password", password_confirmation: "password"})  do
      {:ok, user} -> flunk "User was registered with bad email"
      {:error, errors} -> assert errors
    end
  end

  test "email too short fails" do
    case Blackbook.Commands.register_user(%{email: "ss", password: "password", password_confirmation: "password"})  do
      {:ok, user} -> flunk "User was registered with bad email"
      {:error, errors} -> assert errors
    end
  end

end
