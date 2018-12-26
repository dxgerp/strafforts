require 'rails_helper'

RSpec.describe Api::AthletesController, type: :request do
  let(:expected_folder) { './spec/requests/expected'.freeze }

  describe 'POST subscribe-to-pro' do
    it 'should return 404 when the requested subscription plan does not exist' do
      setup_cookie('4d5cf2bbc714a4e22e309cf5fcf15e40')
      post '/api/athletes/9123806/subscribe-to-pro', params: { subscriptionPlanId: '11111-aaaa-bbbb-2222-1111111111' }
      expect(response).to have_http_status(404)
    end

    it 'should return 404 when the requested athlete does not exist' do
      post '/api/athletes/987654321/subscribe-to-pro'
      expect(response).to have_http_status(404)
    end

    it 'should return 403 when requested athlete is not the current user' do
      setup_cookie(nil)
      post '/api/athletes/9123806/subscribe-to-pro', params: { subscriptionPlanId: '43ab44e0-49c2-46cc-9cfd-66591f9f708c' }
      expect(response).to have_http_status(403)
    end

    it 'should return 402 when Stripe throws an error' do
      setup_cookie('4d5cf2bbc714a4e22e309cf5fcf15e40')
      post '/api/athletes/9123806/subscribe-to-pro', params: { subscriptionPlanId: '43ab44e0-49c2-46cc-9cfd-66591f9f708c' }
      expect(response).to have_http_status(402)
    end
  end
end
