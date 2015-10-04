defmodule Blackbook.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do

    create table :users do
      add :first, :string, size: 50
      add :last, :string, size: 50
      add :email, :string, size: 255
      add :user_key, :string, null: false
      add :validation_token, :string, null: false
      add :password_reset_token, :string, null: false
      add :password_reset_token_expiration, :datetime
      add :status, :string, null: false
      add :last_login, :datetime
      timestamps
    end

    create unique_index :users, [:email]
    create unique_index :users, [:validation_token]
    create unique_index :users, [:user_key]

  end
end
