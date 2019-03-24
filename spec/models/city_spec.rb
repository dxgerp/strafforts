# == Schema Information
#
# Table name: cities
#
#  id         :bigint(8)        not null, primary key
#  country_id :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe City, type: :model do
  it { should validate_presence_of(:name) }

  it { should validate_uniqueness_of(:name).scoped_to(:country_id) }
  it { should_not validate_uniqueness_of(:name) }

  it { should belong_to(:country) }

  it { should have_many(:athlete_infos) }
end
