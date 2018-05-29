class AthletesController < ApplicationController # rubocop:disable ClassLength
  def index
    @auth_url = ApplicationController.get_auth_url(request)
    athlete = Athlete.find_by(id: params[:id])
    ApplicationController.raise_athlete_not_found_error(params[:id]) if athlete.nil?

    @is_current_user = athlete.access_token == cookies.signed[:access_token]
    is_accessible = athlete.is_public || @is_current_user
    ApplicationController.raise_athlete_not_accessible_error(params[:id]) unless is_accessible

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
    athlete = Athlete.find_by(id: params[:id])
    ApplicationController.raise_athlete_not_found_error(params[:id]) if athlete.nil?

    @is_current_user = athlete.access_token == cookies.signed[:access_token]
    is_accessible = athlete.is_public || @is_current_user
    ApplicationController.raise_athlete_not_accessible_error(params[:id]) unless is_accessible

    @athlete = athlete.decorate

    ninety_day_pro_plan = SubscriptionPlan.find_by(name: '90-day PRO')
    @ninety_day_pro_plan = SubscriptionPlanDecorator.decorate(ninety_day_pro_plan)
    annual_pro_plan = SubscriptionPlan.find_by(name: 'Annual PRO')
    @annual_pro_plan = SubscriptionPlanDecorator.decorate(annual_pro_plan)
  end

  def save_profile
    athlete = Athlete.find_by(id: params[:id])
    if athlete.nil?
      Rails.logger.warn("Could not save profile for athlete '#{params[:id]}' that could not be found.")
      render json: { error: ApplicationHelper::Message::ATHLETE_NOT_FOUND }.to_json, status: 404
      return
    end

    @is_current_user = athlete.access_token == cookies.signed[:access_token]
    unless @is_current_user
      Rails.logger.warn("Could not save profile for an athlete #{params[:id]} that is not the currently logged in.")
      render json: { error: ApplicationHelper::Message::ATHLETE_NOT_ACCESSIBLE }.to_json, status: 403
      return
    end

    is_public = params[:is_public].blank? || params[:is_public]
    athlete.update(is_public: is_public)
  end

  def fetch_latest
    athlete = Athlete.find_by(id: params[:id])
    if athlete.nil?
      Rails.logger.warn("Could not fetch latest for athlete '#{params[:id]}' that could not be found.")
      render json: { error: ApplicationHelper::Message::ATHLETE_NOT_FOUND }.to_json, status: 404
      return
    end

    @is_current_user = athlete.access_token == cookies.signed[:access_token]
    unless @is_current_user
      Rails.logger.warn("Could not fetch latest for an athlete #{params[:id]} that is not the currently logged in.")
      render json: { error: ApplicationHelper::Message::ATHLETE_NOT_ACCESSIBLE }.to_json, status: 403
      return
    end

    athlete = athlete.decorate
    unless athlete.pro_subscription?
      render json: { error: ApplicationHelper::Message::PRO_ACCOUNTS_ONLY }.to_json, status: 403
      return
    end

    # Add a delayed_job to fetch the latest data for this athlete.
    fetcher = ::ActivityFetcher.new(athlete.access_token)
    fetcher.delay.fetch_all(mode: 'latest')
  end

  def reset_profile # rubocop:disable MethodLength
    athlete = Athlete.find_by(id: params[:id])
    if athlete.nil?
      Rails.logger.warn("Could not reset profile for an athlete '#{params[:id]}' that could not be found.")
      render json: { error: ApplicationHelper::Message::ATHLETE_NOT_FOUND }.to_json, status: 404
      return
    end

    @is_current_user = athlete.access_token == cookies.signed[:access_token]
    unless @is_current_user
      Rails.logger.warn("Could not reset profile for an athlete #{params[:id]} that is not the currently logged in.")
      render json: { error: ApplicationHelper::Message::ATHLETE_NOT_ACCESSIBLE }.to_json, status: 403
      return
    end

    athlete = athlete.decorate
    unless athlete.pro_subscription?
      render json: { error: ApplicationHelper::Message::PRO_ACCOUNTS_ONLY }.to_json, status: 403
      return
    end

    if params[:is_hard_reset].to_s == 'true'
      # Delete all activity data except for the athlete itself.
      BestEffort.where(athlete_id: athlete.id).destroy_all
      Race.where(athlete_id: athlete.id).destroy_all
      Activity.where(athlete_id: athlete.id).destroy_all
      Rails.logger.warn("Hard resetting all activity data for athlete #{athlete.id}.")
    else
      Rails.logger.warn("Soft resetting all activity data for athlete #{athlete.id}.")
    end

    # Set last_activity_retrieved to nil for this athlete.
    athlete.update(last_activity_retrieved: nil, total_run_count: 0)

    # Add a delayed_job to fetch all data for this athlete.
    fetcher = ::ActivityFetcher.new(athlete.access_token)
    fetcher.delay.fetch_all(mode: 'all')
  end
end
