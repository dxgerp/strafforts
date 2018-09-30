module Api
  class AthletesController < ApplicationController # rubocop:disable ClassLength
    def fetch_latest
      athlete_id = params[:id]
      athlete = Athlete.find_by(id: athlete_id)
      if athlete.nil?
        Rails.logger.warn("Could not perform action for athlete '#{athlete_id}' that could not be found.")
        render json: { error: ApplicationHelper::Message::ATHLETE_NOT_FOUND }.to_json, status: 404
        return
      end

      @is_current_user = athlete.access_token == cookies.signed[:access_token]
      unless @is_current_user
        Rails.logger.warn("Could not save profile for an athlete #{params[:id]} that is not the currently logged in.")
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

    def subscribe_to_pro # rubocop:disable CyclomaticComplexity, MethodLength, AbcSize
      plan_id = params[:subscriptionPlanId]
      subscription_plan = SubscriptionPlan.find_by(id: plan_id)
      if subscription_plan.nil?
        Rails.logger.warn("Could not find the requested subscription plan '#{plan_id}'.")
        render json: { error: ApplicationHelper::Message::PRO_PLAN_NOT_FOUND }.to_json, status: 404
        return
      end

      athlete_id = params[:id]
      athlete = Athlete.find_by(id: athlete_id)
      if athlete.nil?
        Rails.logger.warn("Could not perform action for athlete '#{athlete_id}' that could not be found.")
        render json: { error: ApplicationHelper::Message::ATHLETE_NOT_FOUND }.to_json, status: 404
        return
      end

      @is_current_user = athlete.access_token == cookies.signed[:access_token]
      unless @is_current_user
        Rails.logger.warn("Could not save profile for an athlete #{params[:id]} that is not the currently logged in.")
        render json: { error: ApplicationHelper::Message::ATHLETE_NOT_ACCESSIBLE }.to_json, status: 403
        return
      end

      begin
        athlete = athlete.decorate
        ::StripeApiWrapper.charge(athlete, subscription_plan, params[:stripeToken], params[:stripeEmail])
        ::Creators::SubscriptionCreator.create(athlete, subscription_plan.name)
      rescue Stripe::StripeError => e
        Rails.logger.error("StripeError while subscribing to PRO plan for athlete '#{athlete.id}'. "\
          "Status: #{e.http_status}. Message: #{e.json_body.blank? ? '' : e.json_body[:error][:message]}\n"\
          "Backtrace:\n\t#{e.backtrace.join("\n\t")}")
        render json: { error: "#{ApplicationHelper::Message::STRIPE_ERROR} #{e.json_body.blank? ? '' : e.json_body[:error][:message]}" }.to_json, status: 402
        return
      rescue StandardError => e
        Rails.logger.error("Subscribing to PRO plan '#{subscription_plan.name}' failed for athlete '#{athlete.id}'. "\
          "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
        render json: { error: ApplicationHelper::Message::PAYMENT_FAILED }.to_json, status: 500
        return
      end
    end

    def save_profile
      athlete_id = params[:id]
      athlete = Athlete.find_by(id: athlete_id)
      if athlete.nil?
        Rails.logger.warn("Could not perform action for athlete '#{athlete_id}' that could not be found.")
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

    def reset_profile # rubocop:disable  MethodLength
      athlete_id = params[:id]
      athlete = Athlete.find_by(id: athlete_id)
      if athlete.nil?
        Rails.logger.warn("Could not perform action for athlete '#{athlete_id}' that could not be found.")
        render json: { error: ApplicationHelper::Message::ATHLETE_NOT_FOUND }.to_json, status: 404
        return
      end

      @is_current_user = athlete.access_token == cookies.signed[:access_token]
      unless @is_current_user
        Rails.logger.warn("Could not save profile for an athlete #{params[:id]} that is not the currently logged in.")
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
end
