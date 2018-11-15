class AuthController < ApplicationController
  REQUIRED_SCOPES = ['read', 'read_all', 'activity:read_all', 'profile:read_all'].freeze

  def exchange_token
    if params[:error].blank?
      if params[:scope].split(',').sort == REQUIRED_SCOPES.sort # Make sure all required scopes are returned.
        handle_token_exchange(params[:code])
      else
        Rails.logger.warn("Exchanging token failed due to insufficient scope selected. params[:scope]: #{params[:scope].inspect}.")
        redirect_to '/errors/403'
        return
      end
    else
      # Error returned from Strava side. E.g. user clicked 'Cancel' and didn't authorize.
      Rails.logger.warn("Exchanging token failed due to cancellation of the authorization. params[:error]: #{params[:error].inspect}.")
      redirect_to '/errors/401'
      return
    end

    redirect_to root_path
  end

  def deauthorize
    unless cookies.signed[:access_token].nil?

      # Delete all data.
      athlete = Athlete.find_by_access_token(cookies.signed[:access_token])
      unless athlete.nil?
        athlete_id = athlete.id
        Rails.logger.warn("Deauthrozing and destroying all data for athlete #{athlete_id}.")
        BestEffort.where(athlete_id: athlete_id).destroy_all
        Race.where(athlete_id: athlete_id).destroy_all
        Gear.where(athlete_id: athlete_id).destroy_all
        HeartRateZones.where(athlete_id: athlete_id).destroy_all
        Activity.where(athlete_id: athlete_id).destroy_all
        AthleteInfo.where(athlete_id: athlete_id).destroy_all
        Subscription.where(athlete_id: athlete_id).update_all(is_deleted: true)
        Athlete.where(id: athlete_id).destroy_all
      end

      # Revoke Strava access.
      uri = URI(STRAVA_API_AUTH_DEAUTHORIZE_URL)
      response = Net::HTTP.post_form(uri, 'access_token' => cookies.signed[:access_token])
      if response.is_a? Net::HTTPSuccess
        Rails.logger.info("Revoked Strava access for athlete (access_token=#{cookies.signed[:access_token]}).")
      else
        # Fail to revoke Strava access. Log it and don't throw.
        Rails.logger.error("Revoking Strava access failed. HTTP Status Code: #{response.code}. Response Message: #{response.message}")
      end
    end

    # Log the user out.
    logout
  end

  def logout
    cookies.delete(:access_token)
    redirect_to root_path
  end

  private

  def handle_token_exchange(code) # rubocop:disable AbcSize, MethodLength, CyclomaticComplexity, PerceivedComplexity
    response = Net::HTTP.post_form(
      URI(STRAVA_API_AUTH_TOKEN_URL),
      'code' => code,
      'client_id' => STRAVA_API_CLIENT_ID,
      'client_secret' => ENV['STRAVA_API_CLIENT_SECRET'],
      'grant_type' => 'authorization_code'
    )

    if response.is_a? Net::HTTPSuccess
      result = JSON.parse(response.body)
      access_token = result['access_token']
      athlete = ::Creators::AthleteCreator.create_or_update(access_token, result['athlete'], false)
      ::Creators::RefreshTokenCreator.create(access_token, result['refresh_token'], result['expires_at'])
      ::Creators::HeartRateZonesCreator.create_or_update(result['athlete']['id']) # Create default heart rate zones.

      if ENV['ENABLE_EARLY_BIRDS_PRO_ON_LOGIN'] == 'true'
        # Automatically apply 'Early Birds PRO' Plan on login for everyone for now.
        athlete = athlete.decorate
        begin
          ::Creators::SubscriptionCreator.create(athlete, 'Early Birds PRO') unless athlete.pro_subscription?
        rescue StandardError => e
          Rails.logger.error("Automatically applying 'Early Birds PRO' failed for athlete '#{athlete.id}'. "\
            "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
        end
      end

      if ENV['ENABLE_OLD_MATES_PRO_ON_LOGIN'] == 'true'
        begin
          athlete = athlete.decorate
          if !athlete.pro_subscription? && athlete.returning_after_inactivity?
            ::Creators::SubscriptionCreator.create(athlete, 'Old Mates PRO')
          end
        rescue StandardError => e
          Rails.logger.error("Automatically applying 'Old Mates PRO' failed for athlete '#{athlete.id}'. "\
            "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
        end
      end

      # Subscribe or update to mailing list.
      SubscribeToMailingListJob.perform_later(athlete)

      # Add a delayed_job to fetch data for this athlete.
      fetcher = ::ActivityFetcher.new(access_token)
      fetcher.delay.fetch_all

      # Encrypt and set access_token in cookies.
      cookies.signed[:access_token] = { value: access_token, expires: Time.now + 7.days }
      return
    end

    response_body = response.nil? || response.body.blank? ? '' : "\nResponse Body: #{response.body}"
    raise ActionController::BadRequest, "Bad request while exchanging token with Strava.#{response_body}" if response.code == '400'

    raise "Exchanging token failed. HTTP Status Code: #{response.code}.#{response_body}"
  end
end
