require 'rails_helper'

RSpec.describe Api::AthletesController, type: :request do
  describe 'POST reset-profile' do
    it 'should return 404 when the requested athlete does not exist' do
      post '/api/athletes/12345678/reset-profile'
      expect(response).to have_http_status(404)
    end

    it 'should return 403 when requested athlete is not the current user' do
      setup_cookie(nil)
      post '/api/athletes/9123806/reset-profile'
      expect(response).to have_http_status(403)
    end

    context 'for an athlete without PRO subscription' do
      it 'should return 403 when soft reset-profile even with the correct cookie' do
        # arrange.
        setup_cookie('58e42e6f5e496dc5aa0d5ec354da8048')

        # act.
        post '/api/athletes/456/reset-profile'

        # assert.
        expect(response).to have_http_status(403)
      end

      it 'should return 403 when hard reset-profile even with the correct cookie' do
        # arrange.
        setup_cookie('58e42e6f5e496dc5aa0d5ec354da8048')

        # act.
        post '/api/athletes/456/reset-profile', params: { is_hard_reset: true }

        # assert.
        expect(response).to have_http_status(403)
      end
    end

    context 'for an athlete with PRO subscription' do
      it 'should soft reset-profile successfully with the correct cookie' do
        # arrange.
        setup_cookie('4d5cf2bbc714a4e22e309cf5fcf15e40')

        athlete = Athlete.find_by(id: 9123806)
        expect(athlete).not_to be_nil
        expect(athlete.last_activity_retrieved).not_to be_nil

        best_efforts = BestEffort.where(athlete_id: athlete.id)
        expect(best_efforts.count).to be > 0
        races = Race.where(athlete_id: athlete.id)
        expect(races.count).to be > 0
        activities = Activity.where(athlete_id: athlete.id)
        expect(activities.count).to be > 0

        # act.
        post '/api/athletes/9123806/reset-profile'

        # assert.
        athlete.reload
        expect(athlete.last_activity_retrieved).to be_nil

        best_efforts = BestEffort.where(athlete_id: athlete.id)
        expect(best_efforts.count).to be > 0
        races = Race.where(athlete_id: athlete.id)
        expect(races.count).to be > 0
        activities = Activity.where(athlete_id: athlete.id)
        expect(activities.count).to be > 0
      end

      it 'should hard reset-profile successfully with the correct cookie' do
        # arrange.
        setup_cookie('4d5cf2bbc714a4e22e309cf5fcf15e40')

        athlete = Athlete.find_by(id: 9123806)
        expect(athlete).not_to be_nil
        expect(athlete.last_activity_retrieved).not_to be_nil

        best_efforts = BestEffort.where(athlete_id: athlete.id)
        expect(best_efforts.count).to be > 0
        races = Race.where(athlete_id: athlete.id)
        expect(races.count).to be > 0
        activities = Activity.where(athlete_id: athlete.id)
        expect(activities.count).to be > 0

        # act.
        post '/api/athletes/9123806/reset-profile', params: { is_hard_reset: true }

        # assert.
        athlete.reload
        expect(athlete.last_activity_retrieved).to be_nil

        best_efforts = BestEffort.where(athlete_id: athlete.id)
        expect(best_efforts.count).to be 0
        races = Race.where(athlete_id: athlete.id)
        expect(races.count).to be 0
        activities = Activity.where(athlete_id: athlete.id)
        expect(activities.count).to be 0
      end
    end
  end
end
