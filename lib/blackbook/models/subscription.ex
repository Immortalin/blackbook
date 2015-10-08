defmodule Blackbook.Subscription do

  use Ecto.Model

  @moduledoc """
  Handles notifications and interactions from Stripe and Paypal. Also a model for Ecto.
  """

  schema "subscriptions" do
    field :processor_customer_id
    field :processor, :string, default: "stripe"
    field :plan
    field :discount, :float
    field :price, :float
    field :billing_interval
    field :status
    field :started_at, Ecto.DateTime
    field :ended_at, Ecto.DateTime
    field :trial_start, Ecto.DateTime
    field :trial_end, Ecto.DateTime
    field :canceled_at, Ecto.DateTime
    field :cancel_at_period_end, :boolean
    field :current_period_end, Ecto.DateTime
    field :current_period_start, Ecto.DateTime

    belongs_to :users, Blackbook.User
  end

end







# {
#   "id": "sub_76wzJghPOJF82B",
#   "plan": {
#     "interval": "month",
#     "name": "Premium Plan",
#     "created": 1443746014,
#     "amount": 2900,
#     "currency": "usd",
#     "id": "premium",
#     "object": "plan",
#     "livemode": false,
#     "interval_count": 1,
#     "trial_period_days": null,
#     "metadata": {
#     },
#     "statement_descriptor": null
#   },
#   "object": "subscription",
#   "start": 1444090406,
#   "status": "active",
#   "customer": "cus_765gyBHiSn37Kx",
#   "cancel_at_period_end": false,
#   "current_period_start": 1444090406,
#   "current_period_end": 1446768806,
#   "ended_at": null,
#   "trial_start": null,
#   "trial_end": null,
#   "canceled_at": null,
#   "quantity": 1,
#   "application_fee_percent": null,
#   "discount": null,
#   "tax_percent": null,
#   "metadata": {
#   }
# }
