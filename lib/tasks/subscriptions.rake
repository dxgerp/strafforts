namespace :subscriptions do
  desc 'Automatically renew due subscriptions.'
  # Usage: bundle exec bin/rails subscriptions:renew
  task renew: :environment do
    renewed_ids = []
    athletes = Athlete.find_all_by_is_active(true)
    athletes.each do |athlete|
      athlete = AthleteDecorator.decorate(athlete)
      next if athlete.pro_subscription.blank?
      next unless athlete.pro_subscription.expires_at.today? && !athlete.pro_subscription.cancel_at_period_end?

      subscription_plan = athlete.pro_subscription_plan
      ::StripeApiWrapper.renew(athlete, subscription_plan)
      ::Creators::SubscriptionCreator.create(athlete, subscription_plan.name)

      renewed_ids << athlete.id
    end
    Rails.logger.warn("A total of #{renewed_ids.count} athletes have been renewed: #{renewed_ids.join(',')}")
  end
end
