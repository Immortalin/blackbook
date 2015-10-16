defmodule Blackbook.UserLog do
  use Ecto.Model
  schema "user_logs" do
    field :user_id, :integer
    field :subject, :string
    field :entry, :string
    field :ip, :string, default: "127.0.0.1"
    timestamps
  end
end
