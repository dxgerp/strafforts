require 'rails_helper'

RSpec.describe Api::BestEffortsController, type: :request do
  let(:expected_folder) { './spec/requests/expected'.freeze }

  describe 'GET index' do
    it 'should not find athlete by id who does not exist' do
      expect { get '/api/athletes/12345678/best-efforts' }
        .to raise_error(ActionController::RoutingError, "Could not find the requested athlete '12345678' by id.")
    end

    it 'should be a 404 with an invalid distance' do
      get '/api/athletes/123/best-efforts/100m'
      expect(response).to have_http_status(404)
    end

    it 'should be empty when best effort type is not specified' do
      get '/api/athletes/123/best-efforts'
      expect(response.body).to eq('[]')
    end

    context 'should be successful' do
      distances = BestEffortType.all
      distances.each do |distance|
        it "for best effort type '#{distance.name}'" do
          # arrange.
          url = "/api/athletes/9123806/best-efforts/#{distance.name.tr('/', '_')}"
          expected = "#{expected_folder}#{url}.json"

          # act.
          get URI.encode(url)

          # assert.
          expect(response).to have_http_status(:success)
          expect(response.body).to eq(File.read(expected))
        end
      end
    end
  end

  describe 'GET top_one_by_year' do
    it 'should not find athlete by id who does not exist' do
      expect { get '/api/athletes/12345678/best-efforts/10k/top-one-by-year' }
        .to raise_error(ActionController::RoutingError, "Could not find the requested athlete '12345678' by id.")
    end

    it 'should be a 404 with an invalid distance' do
      get '/api/athletes/123/best-efforts/100m/top-one-by-year'
      expect(response).to have_http_status(404)
    end

    it 'should be empty when best effort type is not specified' do
      get '/api/athletes/123/best-efforts'
      expect(response.body).to eq('[]')
    end

    context 'should be successful' do
      distances = BestEffortType.all
      distances.each do |distance|
        it "for best effort type '#{distance.name}'" do
          # act.
          get URI.encode("/api/athletes/9123806/best-efforts/#{distance.name.tr('/', '_')}/top-one-by-year")

          # assert.
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
