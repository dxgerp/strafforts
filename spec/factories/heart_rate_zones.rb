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

FactoryBot.define do
  factory :heart_rate_zones do
    association :athlete, factory: :athlete

    custom_zones { false }

    zone_1_min { 0 }
    zone_1_max { 140 }
    zone_2_min { 140 }
    zone_2_max { 150 }
    zone_3_min { 150 }
    zone_3_max { 160 }
    zone_4_min { 160 }
    zone_4_max { 170 }
    zone_5_min { 170 }
    zone_5_max { -1 }
  end
end
