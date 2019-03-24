# == Schema Information
#
# Table name: faq_categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
