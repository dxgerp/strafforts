# == Schema Information
#
# Table name: heart_rate_zones
#
#  id           :bigint(8)        not null, primary key
#  athlete_id   :integer
#  custom_zones :boolean
#  zone_1_min   :integer
#  zone_1_max   :integer
#  zone_2_min   :integer
#  zone_2_max   :integer
#  zone_3_min   :integer
#  zone_3_max   :integer
#  zone_4_min   :integer
#  zone_4_max   :integer
#  zone_5_min   :integer
#  zone_5_max   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class HeartRateZones < ApplicationRecord
  validates :athlete_id,
            :zone_1_min, :zone_1_max,
            :zone_2_min, :zone_2_max,
            :zone_3_min, :zone_3_max,
            :zone_4_min, :zone_4_max,
            :zone_5_min, :zone_5_max, presence: true
  validates :athlete_id, uniqueness: true

  belongs_to :athlete, foreign_key: 'athlete_id'

  after_save    :expire_cache
  after_destroy :expire_cache

  def expire_cache
    Rails.cache.delete(format(CacheKeys::HEART_RATE_ZONES, athlete_id: athlete_id))
  end

  def self.find_by_athlete_id(athlete_id)
    Rails.cache.fetch(format(CacheKeys::HEART_RATE_ZONES, athlete_id: athlete_id)) do
      results = where(athlete_id: athlete_id)
      results.empty? ? nil : results.take
    end
  end
end
