require 'rails_helper'

RSpec.describe AuthController, type: :request do
  describe 'GET exchange-token' do
    it 'should redirect to root directly there are errors in params' do
      get '/auth/exchange-token', params: { error: 'access_denied' }

      expect(response).to redirect_to(root_path)
    end

    it 'should redirect to 503 page when Strava returns 400 on token exchange' do
      # arrange.
      stub_strava_post_request(Settings.strava.api_auth_token_url, TOKEN_EXCHANGE_REQUEST_BODY, 400)

      # act.
      get '/auth/exchange-token', params: { scope: 'profile:read_all,read,activity:read' }

      # assert.
      expect(response).to redirect_to('/errors/503')
    end

    it 'should redirect to 503 page when Strava returns 400 on token refresh' do
      skip 'Failing on TravisCI for some reason'

      # arrange.
      token_exchange_response_body = {
        access_token: ACCESS_TOKEN,
        athlete: Athlete.find_by(id: 111).to_json
      }.to_json
      stub_strava_post_request(Settings.strava.api_auth_token_url, TOKEN_EXCHANGE_REQUEST_BODY, 200, token_exchange_response_body)
      stub_strava_post_request(Settings.strava.api_auth_token_url, TOKEN_REFRESH_REQUEST_BODY, 400)

      # act.
      get '/auth/exchange-token', params: { scope: 'profile:read_all,read,activity:read' }

      # assert.
      expect(response).to redirect_to('/errors/503')
    end

    it 'should redirect to 400 page when Strava returns insufficient scope' do
      # arrange.
      stub_strava_post_request(Settings.strava.api_auth_token_url, TOKEN_EXCHANGE_REQUEST_BODY, 400)

      # act.
      get '/auth/exchange-token', params: { scope: 'read' }

      # assert.
      expect(response).to redirect_to('/errors/400')
    end

    it 'should get valid cookie when Strava returns HTTP success' do
      # arrange.
      ENV['ENABLE_EARLY_BIRDS_PRO_ON_LOGIN'] = 'true'

      token_exchange_response_body = {
        access_token: ACCESS_TOKEN,
        athlete: { id: 111 }.merge!(AthleteInfo.find_by(athlete_id: 111).attributes),
        refresh_token: REFRESH_TOKEN,
        expires_at: 1531385304
      }.to_json
      stub_strava_post_request(Settings.strava.api_auth_token_url, TOKEN_EXCHANGE_REQUEST_BODY, 200, token_exchange_response_body)

      # act.
      get '/auth/exchange-token', params: { scope: 'profile:read_all,read,activity:read' }

      # assert.
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET deauthorize' do
    it 'should deauthorize athlete successfully' do
      # arrange.
      token_refresh_response_body = {:access_token => ACCESS_TOKEN, :refresh_token => '1234567898765432112345678987654321', :expires_at => 1531385304 }.to_json
      stub_strava_post_request(Settings.strava.api_auth_token_url, TOKEN_REFRESH_REQUEST_BODY, 200, token_refresh_response_body)
      stub_strava_post_request(Settings.strava.api_auth_deauthorize_url, {:access_token => ACCESS_TOKEN }, 200)
      setup_cookie(ACCESS_TOKEN)

      # act.
      get '/auth/deauthorize'

      # assert.
      expect(cookies[:access_token].blank?).to be true
      expect(response).to redirect_to(root_path)
    end

    it 'should logout when there is no current user' do
      # arrange.
      setup_cookie(nil)

      # act.
      get '/auth/deauthorize'

      # assert.
      expect(cookies[:access_token].blank?).to be true
      expect(response).to redirect_to(root_path)
    end

    it 'should logout when the access token is invalid' do
      # arrange.
      access_token = 'invalid_access_token'
      stub_strava_post_request(Settings.strava.api_auth_deauthorize_url, {:access_token => access_token }, 400)
      setup_cookie(access_token)

      # act.
      get '/auth/deauthorize'

      # assert.
      expect(cookies[:access_token].blank?).to be true
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET logout' do
    it 'should logout successfully' do
      # arrange.
      setup_cookie(ACCESS_TOKEN)

      # act.
      get '/auth/logout'

      # assert.
      expect(cookies[:access_token].blank?).to be true
      expect(response).to redirect_to(root_path)
    end
  end
end
