require 'rails_helper'

RSpec.describe Api::FaqsController, type: :request do
  let(:expected_folder) { './spec/requests/expected'.freeze }

  it 'GET index should be successful' do
    # arrange.
    url = '/api/faqs/index'

    # act.
    get url

    # assert.
    expect(response).to have_http_status(:success)
  end
end
