class StripeCustomer < ApplicationRecord
  belongs_to :athlete, foreign_key: 'athlete_id'

  def self.find_by_email(email)
    results = where('lower(email) = ?', email.downcase)
    results.empty? ? nil : results.take
  end
end
