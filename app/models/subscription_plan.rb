# == Schema Information
#
# Table name: subscription_plans
#
#  id               :uuid             not null, primary key
#  name             :string
#  description      :string
#  duration         :integer
#  amount           :float
#  amount_per_month :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SubscriptionPlan < ApplicationRecord
  validates :name, :description, :amount, :amount_per_month, presence: true

  has_many :subscriptions
end
