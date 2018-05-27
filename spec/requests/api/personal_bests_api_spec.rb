require 'rails_helper'

RSpec.describe Api::PersonalBestsController, type: :request do
  let(:expected_folder) { './spec/requests/expected'.freeze }

  describe 'GET index' do
    it 'should not find athlete by id who does not exist' do
      expect { get '/api/athletes/12345678/personal-bests' }
        .to raise_error(ActionController::RoutingError, "Could not find athlete '12345678' by id.")
    end

    it 'should be a 404 with an invalid distance' do
      get '/api/athletes/123/personal-bests/100m'
      expect(response).to have_http_status(404)
    end

    it 'should be empty when best effort type is not specified' do
      get '/api/athletes/9123806/personal-bests'
      expect(response.body).to eq('[]')
    end

    context 'for an athlete with PRO subscription' do
      it 'should be successful getting items for overview' do
        # arrange.
        url = '/api/athletes/9123806/personal-bests/overview'
        expected = "#{expected_folder}/#{url}.json"

        # act.
        get url

        # assert.
        expect(response).to have_http_status(:success)
        expect(response.body).to eq(File.read(expected))
      end

      it 'should be successful getting recent items' do
        # arrange.
        url = '/api/athletes/9123806/personal-bests/recent'
        expected = "#{expected_folder}/#{url}.json"

        # act.
        get url

        # assert.
        expect(response).to have_http_status(:success)
        expect(response.body).to eq(File.read(expected))
      end

      distances = BestEffortType.all
      distances.each do |distance|
        it "should be successful getting best effort type '#{distance.name}'" do
          # arrange.
          url = "/api/athletes/9123806/personal-bests/#{distance.name.tr('/', '_')}"
          expected = "#{expected_folder}#{url}.json"

          # act.
          get URI.encode(url)

          # assert.
          expect(response).to have_http_status(:success)
          expect(response.body).to eq(File.read(expected))
        end
      end
    end

    context 'for an athlete without PRO subscription' do
      it 'should be successful getting items for overview' do
        # arrange.
        url = '/api/athletes/123/personal-bests/overview'

        # act.
        get url

        # assert.
        expect(response).to have_http_status(:success)
      end

      it 'should be successful getting recent items' do
        # arrange.
        url = '/api/athletes/123/personal-bests/recent'

        # act.
        get url

        # assert.
        expect(response).to have_http_status(:success)
      end

      it 'should be 403 getting a non-major best effort type' do
        # arrange.
        url = '/api/athletes/123/personal-bests/1k'

        # act.
        get url

        # assert.
        expect(response).to have_http_status(403)
      end
    end
  end
end
