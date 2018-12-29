class FaqCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :faqs

  after_save    :expire_cache
  after_destroy :expire_cache

  def expire_cache
    Rails.cache.delete(CacheKeys::FAQ_CATEGORIES)
  end
end
