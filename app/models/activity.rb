# == Schema Information
#
# Table name: activities
#
#  id                   :bigint(8)        not null, primary key
#  athlete_id           :integer
#  gear_id              :string
#  workout_type_id      :integer
#  name                 :string
#  description          :string
#  distance             :float
#  moving_time          :integer
#  elapsed_time         :integer
#  total_elevation_gain :float
#  elev_high            :float
#  elev_low             :float
#  start_date           :datetime
#  start_date_local     :datetime
#  timezone             :string
#  athlete_count        :integer
#  trainer              :boolean
#  commute              :boolean
#  manual               :boolean
#  private              :boolean
#  device_name          :string
#  flagged              :boolean
#  average_speed        :float
#  max_speed            :float
#  average_cadence      :float
#  average_temp         :float
#  has_heartrate        :boolean
#  average_heartrate    :float
#  max_heartrate        :integer
#  calories             :float
#  suffer_score         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Activity < ApplicationRecord
  validates :athlete_id,
            :name,
            :distance,
            :moving_time,
            :elapsed_time,
            :start_date,
            :start_date_local,
            :workout_type_id,
            presence: true

  belongs_to :athlete, foreign_key: 'athlete_id'
  belongs_to :gear, foreign_key: 'gear_id', optional: true
  belongs_to :workout_type, foreign_key: 'workout_type_id'

  has_many :best_efforts
  has_one :race
end
