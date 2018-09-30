class AthletesController < ApplicationController
  include AthleteAccessible
  include AthleteFoundable

  def index
    @auth_url = ApplicationController.get_auth_url(request)
    athlete = find_athlete(params[:id])

    @is_current_user = athlete.access_token == cookies.signed[:access_token]
    check_athlete_accessibility(athlete, cookies)

    @athlete = athlete.decorate

    raw_personal_bests = BestEffort.find_all_pbs_by_athlete_id(athlete.id)
    heart_rate_zones = ApplicationHelper::Helper.get_heart_rate_zones(athlete.id)
    shaped_personal_bests = ApplicationHelper::Helper.shape_best_efforts(
      raw_personal_bests, heart_rate_zones, athlete.athlete_info.measurement_preference
    )
    @personal_bests = PersonalBestsDecorator.new(shaped_personal_bests)

    raw_races = Race.find_all_by_athlete_id(athlete.id)
    shaped_races = ApplicationHelper::Helper.shape_races(
      raw_races, heart_rate_zones, athlete.athlete_info.measurement_preference
    )
    @races = RacesDecorator.new(shaped_races)
  end

  def pro_plans
    @auth_url = ApplicationController.get_auth_url(request)
    athlete_id = params[:id]
    athlete = find_athlete(athlete_id)

    @is_current_user = athlete.access_token == cookies.signed[:access_token]
    check_athlete_accessibility(athlete, cookies)

    @athlete = athlete.decorate
    @page_title = "Get #{Settings.app.name} PRO"

    ninety_day_pro_plan = SubscriptionPlan.find_by(name: '90-day PRO')
    @ninety_day_pro_plan = SubscriptionPlanDecorator.decorate(ninety_day_pro_plan)
    annual_pro_plan = SubscriptionPlan.find_by(name: 'Annual PRO')
    @annual_pro_plan = SubscriptionPlanDecorator.decorate(annual_pro_plan)
  end

  def cancel_pro
    athlete_id = params[:id]
    athlete = find_athlete(athlete_id)

    @is_current_user = athlete.access_token == cookies.signed[:access_token]
    error_message = "Could not cancel PRO plan for athlete '#{athlete_id}' that is not currently logged in."
    raise ActionController::BadRequest, error_message unless @is_current_user

    begin
      ::Creators::SubscriptionCreator.cancel(athlete)
      redirect_to root_path
    rescue StandardError => e
      Rails.logger.error("Cancelling PRO plan failed for athlete '#{athlete.id}'. "\
        "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
      raise e
    end
  end
end
