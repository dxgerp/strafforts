require 'rails_helper'

RSpec.describe HomeController, type: :request do
  let(:expected_folder) { './spec/requests/expected'.freeze }

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
    setup_cookie('58e42e6f5e496dc5aa0d5ec354da8048')

    # act.
    get root_path

    # assert.
    expect(response).to redirect_to('/athletes/456')
  end
end
