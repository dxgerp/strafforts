class Faq < ApplicationRecord
  validates :faq_category_id, :title, :content, presence: true
  belongs_to :faq_category, foreign_key: 'faq_category_id'

  after_save    :expire_cache
  after_destroy :expire_cache

  def expire_cache
    Rails.cache.delete(CacheKeys::FAQS)
  end
end
