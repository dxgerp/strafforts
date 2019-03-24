# == Schema Information
#
# Table name: race_distances
#
#  id         :bigint(8)        not null, primary key
#  distance   :float
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RaceDistance < ApplicationRecord
  validates :distance, presence: true
  validates :distance, uniqueness: true

  has_many :races

  after_save    :expire_cache
  after_destroy :expire_cache

  def expire_cache
    Rails.cache.delete(format(CacheKeys::RACE_DISTANCES, distance: name.downcase))
  end

  def self.find_by_actual_distance(actual_distance)
    all.each do |race_distance|
      distance = race_distance.distance
      next unless actual_distance.between?(distance * 0.965, distance * 1.055) # Allowed margin: 3.5% under or 5.5% over.

      return race_distance
    end
    # If no matching distance was found, find the default RaceDistance called 'Other Distances'.
    results = where(distance: 0)
    results.empty? ? nil : results.take
  end

  def self.find_by_name(distance_name)
    Rails.cache.fetch(format(CacheKeys::RACE_DISTANCES, distance: distance_name.downcase)) do
      results = where('lower(name) = ?', distance_name.downcase)
      results.empty? ? nil : results.take
    end
  end
end
