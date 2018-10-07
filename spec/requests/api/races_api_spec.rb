require 'rails_helper'

RSpec.describe Api::RacesController, type: :request do
  let(:expected_folder) { './spec/requests/expected'.freeze }

  describe 'GET index' do
    it 'should not find athlete by id who does not exist' do
      expect { get '/api/athletes/12345678/races' }
        .to raise_error(ActionController::RoutingError, "Could not find the requested athlete '12345678' by id.")
    end

    it 'should be a 404 with an invalid distance' do
      get '/api/athletes/123/races/100m'
      expect(response).to have_http_status(404)
    end

    it 'should be a 404 with an invalid year prior to 2000' do
      get '/api/athletes/123/races/1999'
      expect(response).to have_http_status(404)
    end

    it 'should get a 404 with an invalid year latter than 2000' do
      # act.
      get '/api/athletes/9123806/races/2002'

      # assert.
      expect(response).to have_http_status(404)
    end

    it 'should be empty when distance or year is not specified' do
      get '/api/athletes/9123806/races'
      expect(response.body).to eq('[]')
    end

    context 'for an athlete without PRO subscription' do
      it "should get 403 when getting race distance '20k' for an athlete without a PRO plan" do
        # arrange.
        url = '/api/athletes/456/races/20k'

        # act.
        get URI.encode(url)

        # assert.
        expect(response).to have_http_status(403)
      end

      it "should get 403 when getting race year '2014' for an athlete without a PRO plan" do
        # arrange.
        url = '/api/athletes/456/races/2014'

        # act.
        get URI.encode(url)

        # assert.
        expect(response).to have_http_status(403)
      end
    end

    context 'for an athlete with PRO subscription' do
      it 'should be successful getting items for overview' do
        # arrange.
        url = '/api/athletes/9123806/races/overview'
        expected = "#{expected_folder}#{url}.json"

        # act.
        get url

        # assert.
        expect(response).to have_http_status(:success)
        expect(response.body).to eq(File.read(expected))
      end

      it 'should be successful getting recent items' do
        # arrange.
        url = '/api/athletes/9123806/races/recent'
        expected = "#{expected_folder}#{url}.json"

        # act.
        get url

        # assert.
        expect(response).to have_http_status(:success)
        expect(response.body).to eq(File.read(expected))
      end

      distances = RaceDistance.all
      distances.each do |distance|
        it "should be successful getting race distance '#{distance.name}'" do
          # arrange.
          url = "/api/athletes/9123806/races/#{distance.name}"
          expected = "#{expected_folder}#{url}.json"

          # act.
          get URI.encode(url)

          # assert.
          expect(response).to have_http_status(:success)
          expect(response.body).to eq(File.read(expected))
        end
      end

      VALID_YEARS = %w[2014 2015 2016].freeze
      VALID_YEARS.each do |year|
        it "should be successful getting race year '#{year}'" do
          # arrange.
          url = "/api/athletes/9123806/races/#{year}"
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
end
