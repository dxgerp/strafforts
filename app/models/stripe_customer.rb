# == Schema Information
#
# Table name: stripe_customers
#
#  id         :string           not null, primary key
#  athlete_id :integer
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StripeCustomer < ApplicationRecord
  validates :athlete_id, :email, presence: true
  validates :athlete_id, uniqueness: true

  belongs_to :athlete, foreign_key: 'athlete_id'

  def self.find_by_email(email)
    results = where('lower(email) = ?', email.downcase)
    results.empty? ? nil : results.take
  end
end
