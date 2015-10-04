defmodule BlackBook.Repo.Migrations.AddLoginsTable do
  use Ecto.Migration

  def change do
    create table :logins do
      add :user_id, references(:users)
      add :provider, :string, default: "local", null: false
      add :provider_key, :string, null: false
      add :provider_token, :string, null: false
      timestamps
    end

    create unique_index(:logins, [:user_id, :provider])
  end
end
