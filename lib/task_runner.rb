class TaskRunner
  def clean_up_inactive_athletes
    destroyed_ids = []
    inactive_athletes = Athlete.where('last_active_at < ?', Time.now.utc - 180.days - 7.days)
    inactive_athletes.each do |athlete|
      begin
        athlete = AthleteDecorator.decorate(athlete)
        next if athlete.pro_subscription?
        destroyed_ids << athlete.id
        destroy_athlete(athlete.id)
      rescue StandardError => e
        Rails.logger.error("Cleaning up inactive athlete failed for athlete '#{athlete.id}'. "\
          "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
        next
      end
    end
    Rails.logger.warn("[athlete:clean_up] - A total of #{destroyed_ids.count} inactive athletes destroyed: #{destroyed_ids.join(',')}.")
  end

  def renew_subscriptions
    renewed_ids = []
    athletes = Athlete.find_all_by_is_active(true)
    athletes.each do |athlete|
      begin
        athlete = AthleteDecorator.decorate(athlete)
        next if athlete.pro_subscription.blank?
        next unless athlete.pro_subscription.expires_at.today? && !athlete.pro_subscription.cancel_at_period_end?

        subscription_plan = athlete.pro_subscription_plan
        ::StripeApiWrapper.renew(athlete, subscription_plan)
        ::Creators::SubscriptionCreator.create(athlete, subscription_plan.name)

        renewed_ids << athlete.id
      rescue StandardError => e
        Rails.logger.error("Renewing subscription failed for athlete '#{athlete.id}'. "\
          "#{e.message}\nBacktrace:\n\t#{e.backtrace.join("\n\t")}")
        next
      end
    end
    Rails.logger.warn("[subscriptions:renew] - A total of #{renewed_ids.count} athletes have been renewed: #{renewed_ids.join(',')}")
  end
end
