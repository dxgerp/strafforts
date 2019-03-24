# == Schema Information
#
# Table name: athletes
#
#  id                       :bigint(8)        not null, primary key
#  access_token             :string
#  is_public                :boolean
#  last_activity_retrieved  :bigint(8)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  is_active                :boolean          default(TRUE)
#  total_run_count          :integer          default(0)
#  last_active_at           :datetime
#  refresh_token            :string
#  refresh_token_expires_at :datetime
#  email_confirmed          :boolean          default(FALSE)
#  confirmation_token       :string
#  confirmation_sent_at     :datetime
#  confirmed_at             :datetime
#

class Athlete < ApplicationRecord
  validates :access_token, presence: true
  validates :is_active, :is_public, inclusion: { in: [true, false] }

  has_one :athlete_info
  has_one :stripe_customer

  has_many :activities
  has_many :best_efforts
  has_many :gears
  has_many :heart_rate_zones
  has_many :races
  has_many :subscriptions

  before_create :generate_confirmation_token

  def self.find_all_by_is_active(is_active = true)
    results = where('is_active = ?', is_active).order('updated_at')
    results.empty? ? [] : results
  end

  def destroy_all_data
    BestEffort.where(athlete_id: id).destroy_all
    Race.where(athlete_id: id).destroy_all
    Gear.where(athlete_id: id).destroy_all
    HeartRateZones.where(athlete_id: id).destroy_all
    Activity.where(athlete_id: id).destroy_all
    AthleteInfo.where(athlete_id: id).destroy_all
    Subscription.where(athlete_id: id).update_all(is_deleted: true)
    Athlete.where(id: id).destroy_all
    Rails.logger.info("Destroying all data for athlete '#{id}' completed.")
  end

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64(32).to_s if confirmation_token.blank?
  end
end
