FactoryBot.define do
  factory :athlete_info do
    association :athlete, factory: :athlete

    email { 'tony.stark@avenger.com' }
  end
end
