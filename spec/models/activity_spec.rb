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

require 'rails_helper'

RSpec.describe Activity, type: :model do
  it { should validate_presence_of(:athlete_id) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:distance) }
  it { should validate_presence_of(:moving_time) }
  it { should validate_presence_of(:elapsed_time) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:start_date_local) }
  it { should validate_presence_of(:workout_type_id) }

  it { should belong_to(:athlete) }
  it { should belong_to(:workout_type) }

  it { should have_many(:best_efforts) }
end
