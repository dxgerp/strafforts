module Creators
  class RefreshTokenCreator
    STRAVA_API_AUTH_TOKEN_URL = Settings.strava.api_auth_token_url
    STRAVA_API_CLIENT_ID = Settings.strava.api_client_id

    def self.create(access_token, refresh_token, expires_at) # rubocop:disable CyclomaticComplexity, PerceivedComplexity, MethodLength
      athlete = Athlete.find_by_access_token(access_token)
      if athlete.nil?
        Rails.logger.warn("RefreshTokenCreator - Could not find requested athlete (access_token=#{access_token}).")
        return
      end

      if refresh_token.blank?
        # No new refresh token passed in. Call Strava now using the existing refresh_token to get a new one.
        # If the current athlete doesn't have refresh_token, use the access_token instead.
        response = Net::HTTP.post_form(
          URI(STRAVA_API_AUTH_TOKEN_URL),
          'refresh_token' => athlete.refresh_token.blank? ? athlete.access_token : athlete.refresh_token,
          'client_id' => STRAVA_API_CLIENT_ID,
          'client_secret' => ENV['STRAVA_API_CLIENT_SECRET'],
          'grant_type' => 'refresh_token'
        )
        if response.is_a? Net::HTTPSuccess
          result = JSON.parse(response.body)
          refresh_token = result['refresh_token']
          expires_at = result['expires_at']
        else
          response_body = response.nil? || response.body.blank? ? '' : "\nResponse Body: #{response.body}"
          raise "Refreshing token failed. HTTP Status Code: #{response.code}.#{response_body}"
        end
      end

      # Save to database.
      Rails.logger.info("RefreshTokenCreator - Update refresh token for athlete #{athlete.id}.")
      athlete.refresh_token = refresh_token
      athlete.refresh_token_expires_at = Time.at(expires_at)
      athlete.save!
    end

    def self.refresh(access_token)
      create(access_token, nil, nil)
    end
  end
end
