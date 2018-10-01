module AthleteAccessible
  include ActiveSupport::Concern

  def check_athlete_accessibility(athlete, cookies)
    is_current_user = athlete.access_token == cookies.signed[:access_token]
    is_accessible = is_current_user || athlete.is_public
    ApplicationController.raise_athlete_not_accessible_error(athlete.id) unless is_accessible
  end
end
