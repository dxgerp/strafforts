class AuthController < ApplicationController # rubocop:disable ClassLength
  REQUIRED_SCOPES = ['read', 'profile:read_all', 'activity:read'].freeze

  def exchange_token
    if params[:error].blank?
      if REQUIRED_SCOPES.all? { |scope| params[:scope].split(',').include?(scope) } # Make sure all required scopes are returned.
        success = handle_token_exchange(params[:code])
        unless success
          redirect_to '/errors/503'
          return
        end
      else
        Rails.logger.warn("Exchanging token failed due to insufficient scope selected. params[:scope]: #{params[:scope].inspect}.")
        redirect_to '/errors/400'
        return
      end
    else
      # Error returned from Strava side. E.g. user clicked 'Cancel' and didn't authorize.
      Rails.logger.warn("Exchanging token failed due to cancellation of the authorization. params[:error]: #{params[:error].inspect}.")
    end

    redirect_to root_path
  end

  def deauthorize # rubocop:disable MethodLength
    access_token = cookies.signed[:access_token]
    unless access_token.nil?
      # Renew athlete's refresh token first.
      begin
        ::Creators::RefreshTokenCreator.refresh(access_token)
      rescue StandardError => e
        Rails.logger.error('Refreshing token while deauthorizing failed. '\
          "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
      end

      # Delete all data.
      athlete = Athlete.find_by_access_token(access_token)
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
      response = Net::HTTP.post_form(uri, 'access_token' => access_token)
      if response.is_a? Net::HTTPSuccess
        Rails.logger.info("Revoked Strava access for athlete (access_token=#{access_token}).")
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

      begin
        ::Creators::RefreshTokenCreator.create(access_token, result['refresh_token'], result['expires_at'])
      rescue StandardError => e
        Rails.logger.error('RefreshTokenCreator - Creation failed. '\
          "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
        return false # Exit. Don't proceed further.
      end

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
          ::Creators::SubscriptionCreator.create(athlete, 'Old Mates PRO') if !athlete.pro_subscription? && athlete.returning_after_inactivity?
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
      return true
    end

    Rails.logger.error("Exchanging token failed from Strava side. HTTP Status Code: #{response.code}.#{response_body}")
    false
  end
end
