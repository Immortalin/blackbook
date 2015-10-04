defmodule BlackBook.Repo.Migrations.AddSubscriptionsTable do
  use Ecto.Migration

  def change do
    create table :subscriptions do
      add :user_id, references(:users)
      add :processor_customer_id, :string, null: false
      add :processor, :string, default: "stripe"
      add :processor_subscription_id, :string, null: false
      add :plan_id, references(:plans)
      add :discount, :decimal, length: 2, precision: 2
      add :price, :decimal, length: 2, precision: 2
      add :billing_interval, :string, default: "monthly"
      add :status, :string, default: "active"
      add :started_at, :datetime
      add :ended_at, :datetime
      add :trial_start, :datetime
      add :trial_end, :datetime
      add :canceled_at, :datetime
      add :cancel_at_period_end, :boolean
      add :current_period_end, :boolean
      add :current_period_start, :boolean
      timestamps
    end
  end
end
