class FaqCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :faqs
end
