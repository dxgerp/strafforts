# == Schema Information
#
# Table name: heart_rate_zones
#
#  id           :bigint(8)        not null, primary key
#  athlete_id   :integer
#  custom_zones :boolean
#  zone_1_min   :integer
#  zone_1_max   :integer
#  zone_2_min   :integer
#  zone_2_max   :integer
#  zone_3_min   :integer
#  zone_3_max   :integer
#  zone_4_min   :integer
#  zone_4_max   :integer
#  zone_5_min   :integer
#  zone_5_max   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe HeartRateZones, type: :model do
  it { should validate_presence_of(:athlete_id) }
  it { should validate_presence_of(:zone_1_min) }
  it { should validate_presence_of(:zone_1_max) }
  it { should validate_presence_of(:zone_2_min) }
  it { should validate_presence_of(:zone_2_max) }
  it { should validate_presence_of(:zone_3_min) }
  it { should validate_presence_of(:zone_3_max) }
  it { should validate_presence_of(:zone_4_min) }
  it { should validate_presence_of(:zone_4_max) }
  it { should validate_presence_of(:zone_5_min) }
  it { should validate_presence_of(:zone_5_max) }

  it { should validate_uniqueness_of(:athlete_id) }

  it { should belong_to(:athlete) }

  describe '.find_by_athlete_id' do
    it 'should get nil when the provided athlete_id matches nothing' do
      # act.
      item = HeartRateZones.find_by_athlete_id(987654321)

      # assert.
      expect(item).to be_nil
    end

    it 'should get heart rate zones matching the provided athlete_id' do
      # act.
      item = HeartRateZones.find_by_athlete_id(9123806)

      # assert.
      expect(item.is_a?(HeartRateZones)).to be true
      expect(item.athlete_id).to eq(9123806)
      expect(item.custom_zones).to be true
    end
  end
end
