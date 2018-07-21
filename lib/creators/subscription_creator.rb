module Creators
  class SubscriptionCreator
    def self.cancel(athlete)
      athlete = AthleteDecorator.decorate(athlete)

      subscription = athlete.pro_subscription
      subscription.cancel_at_period_end = true
      subscription.save!
    end

    def self.create(athlete, subscription_plan_name)
      subscription_plan = SubscriptionPlan.find_by(name: subscription_plan_name)
      raise "Subscription plan '#{subscription_plan_name}' cannot be found." if subscription_plan.blank?

      athlete = AthleteDecorator.decorate(athlete)
      currently_valid_to = athlete.pro_subscription.expires_at

      raise 'The athlete is already on Lifetime PRO plan.' if currently_valid_to.blank?

      # Create a new subscription.
      subscription = Subscription.new
      subscription.athlete_id = athlete.id
      subscription.subscription_plan_id = subscription_plan.id
      subscription.starts_at = currently_valid_to
      subscription.expires_at = currently_valid_to + subscription_plan.duration.days
      subscription.is_deleted = false
      subscription.cancel_at_period_end = false
      subscription.save!
    end
  end
end
