class Subscription < ApplicationRecord
  validates :athlete_id, :subscription_plan_id, :starts_at, presence: true

  belongs_to :athlete, foreign_key: 'athlete_id'
  belongs_to :promo_code, foreign_key: 'promo_code_id', optional: true
  belongs_to :subscription_plan, foreign_key: 'subscription_plan_id'
end
