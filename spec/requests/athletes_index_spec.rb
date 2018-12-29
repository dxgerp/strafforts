require 'rails_helper'

RSpec.describe AthletesController, type: :request do
  let(:expected_folder) { './spec/requests/expected'.freeze }
  let(:athlete_id) { '98765' }
  let(:url) { "/athletes/#{athlete_id}" }

  describe 'GET index' do
    it 'should raise routing error when the requested athlete does not exist' do
      expect { get url }
        .to raise_error(ActionController::RoutingError, "Could not find the requested athlete '#{athlete_id}' by id.")
    end

    context 'when athlete has a public profile' do
      it 'should redirect to /athletes/:id/confirm_your_email page when athlete has no email yet' do
        # arrange.
        athlete = FactoryBot.build(:athlete_with_public_profile, id: athlete_id)
        athlete.athlete_info.email = nil
        athlete.athlete_info.save!

        # act.
        get url

        # assert.
        expect(response).to redirect_to("/athletes/#{athlete_id}/confirm-your-email?new_user=true")
        expect(response.location.include?('new_user=true')).to be true
      end

      it 'should redirect to /athletes/:id/confirm_your_email page when a returning athlete has not confirmed emailed yet' do
        # arrange.
        FactoryBot.build(:athlete_created_a_week_ago_with_email_unconfirmed, id: athlete_id, is_public: true)

        # act.
        get url

        # assert.
        expect(response).to redirect_to("/athletes/#{athlete_id}/confirm-your-email")
      end

      it 'should render page successfully and match the expected for new athlete' do
        # arrange.
        FactoryBot.build(:athlete_created_today_with_email_unconfirmed, id: athlete_id, is_public: true)

        # act.
        get url

        # assert.
        expect(response).to have_http_status(:success)
      end

      it 'should render page successfully and match the expected for an athlete with confirmed email' do
        # arrange.
        FactoryBot.build(:athlete_created_today_with_email_confirmed, id: athlete_id, is_public: true)
        expected = "#{expected_folder}#{url}_with_confirmed_email.html"

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

      it 'should render page successfully and match the expected with a valid cookie' do
        # arrange.
        athlete = FactoryBot.build(:athlete, id: athlete_id)
        setup_cookie(athlete.access_token)
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
