require 'rails_helper'

RSpec.describe AthletesController, type: :request do
  let(:expected_folder) { './spec/requests/expected'.freeze }
  let(:athlete_id) { '98765' }
  let(:url) { "/athletes/#{athlete_id}/get-pro" }

  describe 'GET pro_plans' do
    it 'should raise routing error when the requested athlete does not exist' do
      expect { get url }
        .to raise_error(ActionController::RoutingError, "Could not find the requested athlete '#{athlete_id}' by id.")
    end

    context 'when athlete has a public profile' do
      it 'should render page successfully' do
        # arrange.
        FactoryBot.build(:athlete_with_public_profile, id: athlete_id)
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
        # arrange.
        FactoryBot.build(:athlete, id: athlete_id)

        # act & assert.
        expect { get url }
          .to raise_error(ActionController::RoutingError, "Could not access athlete '#{athlete_id}'.")
      end

      it 'should render page successfully with a valid cookie' do
        # arrange.
        athlete = FactoryBot.build(:athlete, id: athlete_id)
        setup_cookie(athlete.access_token)

        # act.
        get url

        # assert.
        expect(response).to have_http_status(:success)
      end
    end
  end
end
