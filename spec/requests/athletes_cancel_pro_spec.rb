require 'rails_helper'

RSpec.describe AthletesController, type: :request do
  describe 'GET cancel_pro' do
    it 'should return 404 when the requested athlete does not exist' do
      get '/athletes/12345678/cancel-pro'
      expect(response).to have_http_status(404)
    end

    it 'should return 403 when requested athlete is not the current user' do
      setup_cookie(nil)
      get '/athletes/9123806/cancel-pro'
      expect(response).to have_http_status(403)
    end

    it 'should cancel pro subscription successfully' do
      # arrange.
      setup_cookie('4d5cf2bbc714a4e22e309cf5fcf15e40')

      # act.
      get '/athletes/9123806/cancel-pro'

      # assert.
      athlete = Athlete.find_by(id: 9123806).decorate
      subscription = athlete.pro_subscription

      expect(subscription.cancel_at_period_end).to be true
      expect(response).to redirect_to(root_path)
    end
  end
end
