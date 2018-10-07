module AthleteFoundable
  include ActiveSupport::Concern

  def find_athlete(id)
    athlete = Athlete.find_by(id: id)
    ApplicationController.raise_athlete_not_found_error(id) if athlete.nil?

    athlete
  end
end
