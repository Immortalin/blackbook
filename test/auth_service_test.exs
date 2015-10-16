defmodule Blackbook.AuthServicesTest do
  use ExUnit.Case

  setup do
    Blackbook.Repo.delete_all(Blackbook.UserLog)
    Blackbook.Repo.delete_all(Blackbook.Login)
    Blackbook.Repo.delete_all(Blackbook.User)
    {:ok, user} = Blackbook.Commands.register_user(%{email: "joe@test.com", password: "password", password_confirmation: "password"})
    {:ok, user: user}
  end

  test "it works when token matches", %{user: user} do
    login = Blackbook.Repo.get_by(Blackbook.Login, user_id: user.id, provider: "token")
    case Blackbook.Commands.authenticate_user(token: login.provider_token, ip: "127.0.0.1") do
      {:ok, res} -> assert res.id == user.id
      {:error, err} -> flunk err
    end
  end

  test "it fails when token doesnt match", %{user: user} do
    case Blackbook.Commands.authenticate_user(token: "blurgh", ip: "127.0.0.1") do
      {:ok, res} -> flunk "Uh oh you let a bad user in"
      {:error, err} -> assert err
    end
  end

  test "it works for google", %{user: user} do
    login = %Blackbook.Login{user_id: user.id, provider: "google", provider_token: "some_url", provider_key: "test@test.com"}
      |> Blackbook.Repo.insert!

    case Blackbook.Commands.authenticate_user(provider: login.provider, provider_token: login.provider_token, provider_key: login.provider_key, ip: "127.0.0.1") do
      {:ok, res} -> assert res.id == user.id
      {:error, err} -> flunk err
    end

  end

end
