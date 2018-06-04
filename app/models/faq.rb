class Faq < ApplicationRecord
  validates :faq_category_id, :title, :content, presence: true
  belongs_to :faq_category, foreign_key: 'faq_category_id'
end
