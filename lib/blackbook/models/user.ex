defmodule Blackbook.User do
  use Ecto.Model
  use Timex

  import Ecto.Query
  alias Blackbook.Repo

  schema "users" do
    field :first
    field :last
    field :email
    field :user_key, :string, default: SecureRandom.urlsafe_base64()
    field :validation_token, :string, default: SecureRandom.urlsafe_base64()
    field :password_reset_token, :string, default: SecureRandom.urlsafe_base64()
    field :password_reset_token_expiration, Timex.Ecto.DateTime
    field :status, :string,  default: "active"
    field :last_login, Timex.Ecto.DateTime
    has_many :logs, Blackbook.UserLog
    has_many :logins, Blackbook.Login
    timestamps
  end

  def find_by_email(email) do
    Repo.get_by(Blackbook.User, email: email)
  end
  def find_by_key(key) do
    Repo.get_by(Blackbook.User, user_key: key)
  end
  def find_by_reset_token(token) do
    {:ok, now} = Date.local()|> DateFormat.format("{ISO}")

    query = from u in Blackbook.User,
            where: u.password_reset_token == ^token
            and u.password_reset_token_expiration > ^now
    IO.inspect query
    Repo.one query
  end
  def find_login(key, service \\ "local") do
    Repo.get_by(Blackbook.Login, provider_key: key, provider: service)
  end

  def get_logs(user) do
    id = user.id
    query = from l in Blackbook.UserLog,
            where: l.user_id == ^id
    Repo.all query
  end

  def save_and_log(user, change, log_subject, log_entry) do
    Repo.transaction fn ->
      change = changeset(user, change)
      Repo.update change
      Repo.insert %Blackbook.UserLog{subject: log_subject, entry: log_entry, user_id: user.id}
      #reload
      find_by_email user.email
    end
  end

  def suspend(email, reason) do
    change_status email, "suspended", reason
  end

  def ban(email, reason) do
    change_status email, "banned", reason
  end

  def activate(email, reason) do
    change_status email, "active", reason
  end

  defp change_status(email, status, reason) do
    case Blackbook.User.find_by_email(email) do
      user ->
        Blackbook.User.save_and_log user, %{status: status}, "Authentication", "Status set to #{status} because #{reason}"
      nil -> {:error, "This user doesn't exist"}
    end
  end

  @required_fields ~w(email status)
  @optional_fields ~w(last_login first last validation_token password_reset_token password_reset_token_expiration)

  def changeset(model, params \\ :empty) do

    model
    |> cast(params, @required_fields, @optional_fields)
  end

end
