# == Schema Information
#
# Table name: countries
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Country < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :athlete_infos
  has_many :cities
  has_many :states
end
