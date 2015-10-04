defmodule BlackBook.Repo.Migrations.AddPlansTable do
  use Ecto.Migration

  def change do
    create table :plans do
      add :slug, :string
      add :name, :string
      add :description, :string
      add :price, :decimal, length: 10, precision: 2
      add :billing_interval, :string, default: "monthly"
      add :currency, :string, default: "USD"
      add :trial_period_days, :integer, default: 14
      add :statement_descriptor, :string
      timestamps
    end
  end
end
