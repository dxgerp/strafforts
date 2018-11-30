require 'rails_helper'

RSpec.describe AthletesController, type: :request do
  describe 'GET cancel_pro' do
    it 'should raise routing error when the requested athlete does not exist' do
      expect { get '/athletes/12345678/cancel-pro' }
        .to raise_error(ActionController::RoutingError, "Could not find the requested athlete '12345678' by id.")
    end

    it 'should redirect to 403 page when requested athlete is not the current user' do
      # arrage.
      setup_cookie(nil)

      # act.
      get '/athletes/9123806/cancel-pro'

      # assert.
      expect(response).to redirect_to('/errors/403')
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
