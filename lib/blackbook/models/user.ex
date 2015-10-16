defmodule Blackbook.User do
  use Ecto.Model
  use Timex

  import Ecto.Query
  alias Blackbook.Repo

  schema "users" do
    field :first
    field :last
    field :email
    field :password_hash, :string, virtual: true
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

  @required_fields ~w(email status)
  @optional_fields ~w(last_login first last validation_token password_reset_token password_reset_token_expiration)


  def changeset(model, params \\ :empty) do
    model
      |> cast(params, @required_fields, @optional_fields)
      |> validate_format(:email, ~r/[@\.]/,  message: "This email appears invalid")
      |> validate_length(:email, min: 5, message: "This email appears invalid")
  end

  def registration_changeset(model, params \\ :empty) do
    model
      |> changeset(params)
      |> passwords_match
      |> unique_constraint(:email, message: "This email already exists in our system")
      |> hash_password
  end


  defp passwords_match(changeset) do
    pass = changeset.params["password"]
    confirm = changeset.params["password_confirmation"]
    case pass == confirm do
      false ->  Ecto.Changeset.add_error(changeset, :password, "Passwords don't match")
      true -> changeset
    end
  end

  defp hash_password(changeset)  do
    if changeset.valid? do
      pass = changeset.params["password"]
      #Change the password rules here - see Comeonin for details
      case Comeonin.create_hash(pass, [min_length: 6, extra_chars: false, common: false]) do
        {:ok, hash} -> Ecto.Changeset.put_change changeset, :password_hash, hash
        {:error, err} -> Ecto.Changeset.add_error changeset, :password, err
      end
    else
      changeset
    end
  end


end
