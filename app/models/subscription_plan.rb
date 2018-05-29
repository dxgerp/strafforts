class SubscriptionPlan < ApplicationRecord
  validates :name, :description, :amount, :amount_per_month, presence: true

  has_many :subscriptions
end
