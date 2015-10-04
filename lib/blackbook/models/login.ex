defmodule Blackbook.Login do
  use Ecto.Model
  schema "logins" do
    field :user_id, :integer
    field :provider, :string, default: "local"
    field :provider_key, :string
    field :provider_token, :string
    timestamps
  end

  @required_fields ~w(user_id provider_token provider_key)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end


end
