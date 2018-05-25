module Creators
  class SubscriptionCreator
    def self.create(subscription_plan_name, athlete_id)
      subscription_plan = SubscriptionPlan.find_by(name: subscription_plan_name)
      raise "Subscription plan '#{subscription_plan_name}' cannot be found." if subscription_plan.blank?

      # Expire all current subscriptions first.
      current_subscriptions = Subscription.where(athlete_id: athlete_id)
      current_subscriptions.each do |current_subscription|
        expires_at = current_subscription.expires_at
        current_subscription.expires_at = Time.now.utc if expires_at.nil? || expires_at > Time.now.utc
        current_subscription.save!
      end
  
      # Create a new subscription.
      plan_duration = subscription_plan.duration
      subscription = Subscription.new
      subscription.athlete_id = athlete_id
      subscription.subscription_plan_id = subscription_plan.id
      subscription.starts_at = Time.now.utc
      subscription.expires_at = plan_duration.blank? ? nil : Time.now.utc + plan_duration.days # It's Lifetime PRO when expires_at is nil.
      subscription.save!
    end
  end
end
