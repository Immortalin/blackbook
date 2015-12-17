defmodule Blackbook.Repo do
  use Ecto.Repo, otp_app: Application.get_env(:blackbook, :app_name)
  # Application.get_env(:blackbook, :repo)
end
