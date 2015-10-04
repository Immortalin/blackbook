defmodule Blackbook.UserLog do
  use Ecto.Model
  schema "user_logs" do
    field :user_id, :integer
    field :subject, :string
    field :entry, :string
    timestamps
  end
end
