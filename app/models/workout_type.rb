# == Schema Information
#
# Table name: workout_types
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WorkoutType < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :activities
end
