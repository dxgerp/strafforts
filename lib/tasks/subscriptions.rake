namespace :subscriptions do
  desc 'Automatically renew due subscriptions.'
  # Usage: bundle exec bin/rails subscriptions:renew
  task renew: :environment do
    renewed_ids = []
    athletes = Athlete.find_all_by_is_active(true)
    athletes.each do |athlete|
      athlete = AthleteDecorator.decorate(athlete)
      expires_at = athlete.pro_subscription_expires_at
      next unless DateTime.parse(expires_at).today?

      subscription_plan = athlete.pro_subscription_plan
      ::StripeApiWrapper.renew(athlete, subscription_plan)
      ::Creators::SubscriptionCreator.create(subscription_plan.name, athlete.id)

      renewed_ids << athlete.id
    end
    Rails.logger.warn("A total of #{renewed_ids.count} athletes have been renewed: #{renewed_ids.join(',')}.")
  end
end
