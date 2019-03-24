# == Schema Information
#
# Table name: gears
#
#  gear_id     :string           not null, primary key
#  athlete_id  :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  primary     :boolean          default(FALSE)
#  distance    :float
#  brand_name  :string
#  model       :string
#  description :string
#

class Gear < ApplicationRecord
  validates :athlete_id, :name, :gear_id, presence: true
  validates :gear_id, uniqueness: true

  belongs_to :athlete, foreign_key: 'athlete_id'

  has_many :activities
end
