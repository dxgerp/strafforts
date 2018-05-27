module Creators
  class SubscriptionCreator
    def self.create(subscription_plan_name, athlete_id)
      subscription_plan = SubscriptionPlan.find_by(name: subscription_plan_name)
      raise "Subscription plan '#{subscription_plan_name}' cannot be found." if subscription_plan.blank?

      # Find out what date it's currently valid to.
      is_currently_indefinite = false
      currently_valid_to = Time.now.utc # Initialize to now, so it can be compared.
      current_subscriptions = Subscription.find_all_by_athlete_id(athlete_id)
      current_subscriptions.each do |current_subscription|
        expires_at = current_subscription.expires_at
        if expires_at.nil?
          is_currently_indefinite = true
          break
        elsif expires_at > currently_valid_to
          currently_valid_to = expires_at
        end
      end

      raise 'The athlete is already on Lifetime PRO plan.' if is_currently_indefinite

      # Create a new subscription.
      subscription = Subscription.new
      subscription.athlete_id = athlete_id
      subscription.subscription_plan_id = subscription_plan.id
      subscription.starts_at = currently_valid_to
      subscription.expires_at = currently_valid_to + subscription_plan.duration.days
      subscription.is_deleted = false
      subscription.save!
    end
  end
end
