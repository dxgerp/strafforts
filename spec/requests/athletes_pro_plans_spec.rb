require 'rails_helper'

RSpec.describe AthletesController, type: :request do
  let(:expected_folder) { './spec/requests/expected'.freeze }

  describe 'GET pro_plans' do
    it 'should not find athlete when id matches nothing' do
      expect { get '/athletes/12345678/get-pro' }
        .to raise_error(ActionController::RoutingError, "Could not find athlete '12345678' by id.")
    end

    context 'when athlete has a public profile' do
      it 'should render page successfully' do
        # arrange.
        setup_cookie(nil)
        url = '/athletes/9123806/get-pro'
        expected = "#{expected_folder}#{url}.html"

        # act.
        get url

        # assert.
        expect(response).to have_http_status(:success)

        FileHelpers.write_expected_file(expected, response.body)
        # skip 'CSS and JS contain hash again after upgrading webpacker.'
        # expect(response.body).to eq(File.read(expected))
      end
    end

    context 'when athlete has a private profile' do
      it 'should not get page without valid cookie' do
        setup_cookie(nil)

        expect { get '/athletes/123/get-pro' }
          .to raise_error(ActionController::RoutingError, "Could not access athlete '123'.")
      end

      it 'should render page successfully with a valid cookie' do
        # arrange.
        setup_cookie('3f2a45886980ebec9f4a689371e95860')
        url = '/athletes/123/get-pro'
        expected = "#{expected_folder}#{url}.html"

        # act.
        get url

        # assert.
        expect(response).to have_http_status(:success)

        FileHelpers.write_expected_file(expected, response.body)
        # skip 'CSS and JS contain hash again after upgrading webpacker.'
        # expect(response.body).to eq(File.read(expected))
      end
    end
  end
end
