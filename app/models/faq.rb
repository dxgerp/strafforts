# == Schema Information
#
# Table name: faqs
#
#  id              :bigint(8)        not null, primary key
#  faq_category_id :integer
#  title           :text
#  content         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Faq < ApplicationRecord
  validates :faq_category_id, :title, :content, presence: true
  belongs_to :faq_category, foreign_key: 'faq_category_id'

  after_save    :expire_cache
  after_destroy :expire_cache

  def expire_cache
    Rails.cache.delete(CacheKeys::FAQS)
  end
end
