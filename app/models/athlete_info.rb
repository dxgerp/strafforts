# == Schema Information
#
# Table name: athlete_infos
#
#  athlete_id             :integer          not null, primary key
#  username               :string
#  firstname              :string
#  lastname               :string
#  email                  :string
#  profile_medium         :string
#  profile                :string
#  city_id                :integer
#  state_id               :integer
#  country_id             :integer
#  sex                    :string
#  follower_count         :integer
#  friend_count           :integer
#  athlete_type           :integer
#  date_preference        :string
#  measurement_preference :string
#  weight                 :float
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class AthleteInfo < ApplicationRecord
  belongs_to :athlete, foreign_key: 'athlete_id'
  belongs_to :city, foreign_key: 'city_id', optional: true
  belongs_to :state, foreign_key: 'state_id', optional: true
  belongs_to :country, foreign_key: 'country_id', optional: true

  validates_format_of :email, allow_nil: true, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  before_destroy :remove_from_mailing_list

  def self.find_by_email(email)
    results = where('lower(email) = ?', email.downcase)
    results.empty? ? nil : results.take
  end

  private

  def remove_from_mailing_list
    RemoveFromMailingListWorker.perform_async(athlete_id, email)
  end
end
