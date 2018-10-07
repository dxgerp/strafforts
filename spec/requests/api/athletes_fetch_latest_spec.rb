require 'rails_helper'

RSpec.describe Api::AthletesController, type: :request do
  describe 'POST fetch-latest' do
    it 'should return 404 when the requested athlete does not exist' do
      post '/api/athletes/12345678/fetch-latest'
      expect(response).to have_http_status(404)
    end

    it 'should return 403 when requested athlete is not the current user' do
      setup_cookie(nil)
      post '/api/athletes/9123806/fetch-latest'
      expect(response).to have_http_status(403)
    end

    context 'for an athlete with PRO subscription' do
      it 'should fetch-latest successfully with the correct cookie' do
        # arrange.
        setup_cookie('4d5cf2bbc714a4e22e309cf5fcf15e40')

        # act.
        post '/api/athletes/9123806/fetch-latest'

        # assert.
        expect(response).to have_http_status(:success)
      end
    end

    context 'for an athlete without PRO subscription' do
      it 'should be 403 even with the correct cookie' do
        # arrange.
        setup_cookie('58e42e6f5e496dc5aa0d5ec354da8048')

        # act.
        post '/api/athletes/456/fetch-latest'

        # assert.
        expect(response).to have_http_status(403)
      end
    end
  end
end
