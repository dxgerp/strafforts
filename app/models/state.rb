# == Schema Information
#
# Table name: states
#
#  id         :bigint(8)        not null, primary key
#  country_id :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class State < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { scope: :country_id }

  belongs_to :country, foreign_key: 'country_id'

  has_many :athlete_infos
end
