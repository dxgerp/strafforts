class AthleteDecorator < Draper::Decorator
  delegate_all

  STRAVA_URL = Settings.strava.url
  MAX_INFO_TEXT_LENGTH = 25

  def profile_url
    return "#{STRAVA_URL}/athletes/#{object.id}" unless object.id.blank?
    nil
  end

  def profile_image_url
    object.athlete_info.profile if valid_url?(object.athlete_info.profile)
  end

  def pro_subscription?
    unless object.subscriptions.nil?
      object.subscriptions.each do |subscription|
        is_deleted = subscription.is_deleted
        expires_at = subscription.expires_at
        return true if !is_deleted && (expires_at.blank? || expires_at > Time.now.utc)
      end
    end
    false
  end

  def pro_subscription_expires_at
    if pro_subscription?
      currently_valid_to = Time.now.utc # Initialize to now, so it can be compared.
      object.subscriptions.each do |subscription|
        is_deleted = subscription.is_deleted
        expires_at = subscription.expires_at
        return 'Indefinite' if !is_deleted && expires_at.blank? # Lifetime PRO has no expiration date.

        currently_valid_to = expires_at if !is_deleted && expires_at > currently_valid_to
      end
      return currently_valid_to.strftime('%Y/%m/%d')
    end
    nil
  end

  def following_url
    return "#{profile_url}/follows?type=following" unless object.id.blank?
    nil
  end

  def follower_url
    return "#{profile_url}/follows?type=followers" unless object.id.blank?
    nil
  end

  def fullname
    if object.athlete_info.firstname.blank? && object.athlete_info.lastname.blank?
      'Strava User'
    else
      "#{object.athlete_info.firstname} #{object.athlete_info.lastname}".to_s.strip
    end
  end

  def display_name
    return fullname unless fullname.length > MAX_INFO_TEXT_LENGTH
    return object.athlete_info.firstname unless object.athlete_info.firstname.blank?
    return object.athlete_info.lastname unless object.athlete_info.lastname.blank?
  end

  def location # rubocop:disable AbcSize, CyclomaticComplexity, PerceivedComplexity
    return '' if object.athlete_info.city.nil? && object.athlete_info.country.nil?
    return object.athlete_info.country.name.to_s.strip if object.athlete_info.city.nil?
    return object.athlete_info.city.name.to_s.strip if object.athlete_info.country.nil?

    return '' if object.athlete_info.city.name.blank? && object.athlete_info.country.name.blank?
    return object.athlete_info.country.name.to_s.strip if object.athlete_info.city.name.blank?
    return object.athlete_info.city.name.to_s.strip if object.athlete_info.country.name.blank?
    "#{object.athlete_info.city.name.to_s.strip}, #{object.athlete_info.country.name.to_s.strip}"
  end

  def display_location
    return location unless location.length > MAX_INFO_TEXT_LENGTH
    return object.athlete_info.city.name unless object.athlete_info.city.nil? || object.athlete_info.city.name.blank?
    return object.athlete_info.country.name unless object.athlete_info.country.nil? || object.athlete_info.country.name.blank? # rubocop:disable LineLength
  end

  def friend_count
    if object.athlete_info.friend_count.blank?
      '0'
    else
      object.athlete_info.friend_count.to_s.strip
    end
  end

  def follower_count
    if object.athlete_info.follower_count.blank?
      '0'
    else
      object.athlete_info.follower_count.to_s.strip
    end
  end

  def heart_rate_zones
    ApplicationHelper::Helper.get_heart_rate_zones(object.id)
  end

  def returning_after_inactivity?
    inactivity_days_threshold = ENV['INACTIVITY_DAYS_THRESHOLD'].to_i || 180
    athlete.last_active_at.blank? || athlete.last_active_at.to_date < Date.today - inactivity_days_threshold.days
  end

  private

  def valid_url?(string)
    uri = URI.parse(string)
    %w[http https ftp].include?(uri.scheme)
  rescue URI::InvalidURIError
    false
  end
end
