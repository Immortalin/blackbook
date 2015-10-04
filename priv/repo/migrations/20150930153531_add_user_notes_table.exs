defmodule BlackBook.Repo.Migrations.AddUserNotesTable do
  use Ecto.Migration

  def change do
    create table :user_notes do
      add :user_id, references(:users)
      add :entry, :string, null: false
      timestamps
    end
  end
end
