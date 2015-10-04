defmodule Blackbook.RegistrationTest do
  use ExUnit.Case
  alias Blackbook.User

  setup do

    #delete the users if they are there
    Blackbook.Repo.delete_all(Blackbook.Login)
    Blackbook.Repo.delete_all(Blackbook.UserLog)
    Blackbook.Repo.delete_all(User)
    case Blackbook.Registration.submit_application({"test@test.com", "password", "password"}) do
       {:ok, res} -> {:ok,[res: res]}
       {:error, err} -> raise err
    end
  end

  test "with valid credentials succeeds", %{res: res} do
    assert res.id
  end

  test "with duplicate credentials fails" do
    case Blackbook.Registration.submit_application({"test@test.com", "password", "password"}) do
      {:ok, _} -> flunk "Duplication is not good"
      {:error, message} -> assert message == "This email already exists in our system"
    end
  end

  test "creates logs", %{res: res} do
    logs = User.get_logs(res)
    assert length(logs) > 0
  end

  test "mismatched passwords fail" do
    case Blackbook.Registration.submit_application({"test@test.com", "password", "asdasd"}) do
      {:ok, _} -> flunk "Passwords aren't matching"
      {:error, message} -> assert message == "Password and confirm do not match"
    end
  end

  test "email too short fails" do
    case Blackbook.Registration.submit_application({"d", "password", "password"}) do
      {:ok, _} -> flunk "Email is invalid"
      {:error, message} -> assert message == "Email appears to be invalid"
    end
  end

  test "email without @ and . fails" do
    case Blackbook.Registration.submit_application({"butterbutter", "password", "password"}) do
      {:ok, _} -> flunk "Email is invalid"
      {:error, message} -> assert message == "Email appears to be invalid"
    end
  end

end
