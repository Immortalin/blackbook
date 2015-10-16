defmodule Blackbook.UserTest do

  use ExUnit.Case
  alias Blackbook.User


  test "model is valid when email is given with normal changeset" do
    change = User.changeset(%User{}, %{email: "test@test.com"})
    assert change.valid?, change.errors
  end

  test "model is valid when email is given and password with confirm on reg changeset" do
    change = User.registration_changeset(%User{}, %{email: "test@test.com", password: "password", password_confirmation: "password"})
    assert change.valid?, change.errors
  end

  test "model is not valid when email is given and password with confirm dont match" do
    change = User.registration_changeset(%User{}, %{email: "test@test.com", password: "password", password_confirmation: "asdad"})
    refute change.valid?
  end

end
