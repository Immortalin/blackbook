defmodule Blackbook.Repo.Migrations.AddUserLogsTable do
  use Ecto.Migration

  def change do
    create table :user_logs do
      add :subject, :string, null: false
      add :user_id, references(:users)
      add :entry, :string, null: false
      timestamps
    end
  end
end
