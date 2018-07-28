require 'rails_helper'

RSpec.describe AthletesController, type: :request do
  describe 'GET cancel_pro' do
    it 'should raise routing error when the requested athlete does not exist' do
      expect { get '/athletes/12345678/cancel-pro' }
        .to raise_error(ActionController::RoutingError, "Could not find the requested athlete '12345678'.")
    end

    it 'should raise bad request error when requested athlete is not the current user' do
      setup_cookie(nil)
      expect { get '/athletes/9123806/cancel-pro' }
        .to raise_error(ActionController::BadRequest, "Could not cancel PRO plan for athlete '9123806' that is not currently logged in.")
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
