class DeauthorizeAthleteWorkerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', backtrace: true, retry: 0

  STRAVA_API_AUTH_DEAUTHORIZE_URL = Settings.strava.api_auth_deauthorize_url

  def perform(access_token)
    raise ArgumentError, 'DeauthorizeAthleteWorkerWorker - Access token is blank.' if access_token.blank?

    # Renew athlete's refresh token first.
    begin
      access_token = ::Creators::RefreshTokenCreator.refresh(access_token)
    rescue StandardError => e
      Rails.logger.error('Refreshing token while deauthorizing failed. '\
        "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
    end

    # Revoke Strava access.
    uri = URI(STRAVA_API_AUTH_DEAUTHORIZE_URL)
    response = Net::HTTP.post_form(uri, 'access_token' => access_token)
    if response.is_a? Net::HTTPSuccess
      Rails.logger.info("Revoked Strava access for athlete (access_token=#{access_token}).")
    else
      # Fail to revoke Strava access. Log it and don't throw.
      Rails.logger.error("Revoking Strava access failed. HTTP Status Code: #{response.code}. Response Message: #{response.message}")
    end

    # Delete all data.
    athlete = Athlete.find_by(access_token: access_token)
    unless athlete.nil?
      athlete_id = athlete.id
      Rails.logger.warn("Deauthorizing and destroying all data for athlete #{athlete_id}.")
      BestEffort.where(athlete_id: athlete_id).destroy_all
      Race.where(athlete_id: athlete_id).destroy_all
      Gear.where(athlete_id: athlete_id).destroy_all
      HeartRateZones.where(athlete_id: athlete_id).destroy_all
      Activity.where(athlete_id: athlete_id).destroy_all
      AthleteInfo.where(athlete_id: athlete_id).destroy_all
      Subscription.where(athlete_id: athlete_id).update_all(is_deleted: true)
      Athlete.where(id: athlete_id).destroy_all
    end
  end
end
