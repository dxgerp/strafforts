# == Schema Information
#
# Table name: subscriptions
#
#  id                   :bigint(8)        not null, primary key
#  athlete_id           :integer
#  subscription_plan_id :uuid
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  starts_at            :datetime
#  expires_at           :datetime
#  is_deleted           :boolean          default(FALSE)
#  is_active            :boolean          default(TRUE)
#  cancel_at_period_end :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should validate_presence_of(:athlete_id) }
  it { should validate_presence_of(:subscription_plan_id) }
  it { should validate_presence_of(:starts_at) }

  it { should belong_to(:athlete) }
  it { should belong_to(:subscription_plan) }

  it 'should get subscriptions by athlete ID' do
    # act.
    items = Subscription.find_all_by_athlete_id(333)

    # assert.
    expect(items.count).to eq(2)
    items.each do |item|
      expect(item.is_deleted).to be false
    end
  end

  it 'should get deleted subscriptions by athlete ID' do
    # act.
    items = Subscription.find_all_by_athlete_id(333, true)

    # assert.
    expect(items.count).to eq(1)
    items.each do |item|
      expect(item.is_deleted).to be true
    end
  end
end
