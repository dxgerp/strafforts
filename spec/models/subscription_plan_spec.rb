# == Schema Information
#
# Table name: subscription_plans
#
#  id               :uuid             not null, primary key
#  name             :string
#  description      :string
#  duration         :integer
#  amount           :float
#  amount_per_month :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe SubscriptionPlan, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:amount_per_month) }

  it { should have_many(:subscriptions) }
end
