# == Schema Information
#
# Table name: faqs
#
#  id              :bigint(8)        not null, primary key
#  faq_category_id :integer
#  title           :text
#  content         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Faq, type: :model do
  it { should validate_presence_of(:faq_category_id) }

  it { should belong_to(:faq_category) }
end
