require 'rails_helper'

RSpec.describe HomeController, type: :request do
  let(:expected_folder) { './spec/requests/expected'.freeze }
  let(:athlete_id) { '98765' }

  describe 'GET index' do
    it 'should render page when there is no access_token in cookies' do
      # arrange.
      setup_cookie(nil)
      expected = "#{expected_folder}/index.html"

      # act.
      get root_path

      # assert.
      expect(response).to have_http_status(:success)

      FileHelpers.write_expected_file(expected, response.body)
      # skip 'CSS and JS contain hash again after upgrading webpacker.'
      # expect(response.body).to eq(File.read(expected))
    end
  end

  it 'should logout when access token in cookies does not match any athletes' do
    # arrange.
    setup_cookie('dummy_access_token')

    # act.
    get root_path

    # assert.
    expect(cookies[:access_token]).to eq('')
    expect(response).to redirect_to(root_path)
  end

  it 'should redirect to athlete page for the current user' do
    # arrange.
    athlete = FactoryBot.build(:athlete_with_public_profile, id: athlete_id)
    setup_cookie(athlete.access_token)

    # act.
    get root_path

    # assert.
    expect(response).to redirect_to("/athletes/#{athlete_id}")
  end
end
