defmodule BlackBook.Login do
  use Ecto.Model
  schema "logins" do
    field :user_id, :integer
    field :provider, :string, default: "local"
    field :provider_key, :string
    field :provider_token, :string
    timestamps
  end
end
