class BestEffortType < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :best_efforts

  after_save    :expire_cache
  after_destroy :expire_cache

  def expire_cache
    Rails.cache.delete(CacheKeys::BEST_EFFORT_TYPES % { distance: name.downcase })
  end

  def self.find_by_name(distance_name)
    Rails.cache.fetch(CacheKeys::BEST_EFFORT_TYPES % { distance: distance_name.downcase }) do
      results = where('lower(name) = ?', distance_name.downcase)
      results.empty? ? nil : results.take
    end
  end
end
