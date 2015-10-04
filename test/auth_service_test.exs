defmodule Blackbook.AuthServicesTest do
  use ExUnit.Case

  # setup do
  #   DB.Runner.execute("delete from Blackbook.users")
  #   {:ok, reg} = Blackbook.Registration.new_application({"test@test.com", "password"})
  #
  #   case Blackbook.Authentication.by_auth_token(reg.authentication_token) do
  #     {:ok, auth_res} -> {:ok, [res: auth_res]}
  #     {:error, err} -> raise err
  #   end
  # end
  #
  # test "Auth with valid token is successful", %{res: auth_res} do
  #   assert auth_res.success,auth_res.message
  # end
  #
  #
  # test "Adding a valid service and logging in with it is successful" do
  #   {:ok, res} = Blackbook.Authentication.add_service("test@test.com", "some_service", "key", "token")
  #   assert res.success
  #   {:ok, auth_res} = Blackbook.Authentication.by_service("some_service", "key", "token")
  #   assert auth_res.success
  # end

end
