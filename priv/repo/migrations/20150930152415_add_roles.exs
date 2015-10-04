defmodule Blackbook.Repo.Migrations.AddRoles do
  use Ecto.Migration

  def up do
    create table :roles, primary_key: false do
      add :id, :integer, primary_key: true
      add :name, :string, null: false
      add :description, :string
      timestamps
    end

    create table :roles_users do
      add :user_id, references(:users)
      add :role_id, references(:roles)
      timestamps
    end

    create unique_index(:roles_users, [:user_id, :role_id])
    execute("insert into roles(id, name, description, inserted_at, updated_at)
            values(99, 'Administrator', 'Super Admin', '#{Ecto.DateTime.local()}',  '#{Ecto.DateTime.local()}')")
  end

  def down do
    execute "drop table roles_users cascade;"
    execute "drop table roles cascade;"
  end
end
