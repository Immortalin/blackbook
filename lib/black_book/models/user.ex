defmodule BlackBook.User do
  use Ecto.Model
  import Ecto.Query

  schema "users" do
    field :first
    field :last
    field :email
    field :user_key, :string, default: SecureRandom.urlsafe_base64()
    field :validation_token, :string, default: SecureRandom.urlsafe_base64()
    field :status, :string,  default: "active"
    field :last_login, Ecto.DateTime
    has_many :logs, BlackBook.UserLog
    has_many :logins, BlackBook.Login
    timestamps
  end

  def find_by_email(email) do
    BlackBook.Repo.get_by(BlackBook.User, email: email)
  end

  def find_login(key, service \\ "local") do
    BlackBook.Repo.get_by(BlackBook.Login, provider_key: key, provider: service)
  end

  def get_logs(user) do
    id = user.id
    query = from l in BlackBook.UserLog,
            where: l.user_id == ^id
    BlackBook.Repo.all query
  end

  @required_fields ~w(email status)
  @optional_fields ~w(last_login first last validation_token)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end
