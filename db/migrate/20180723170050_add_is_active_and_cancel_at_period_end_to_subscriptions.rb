class AddIsActiveAndCancelAtPeriodEndToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :is_active, :boolean, :default => true
    add_column :subscriptions, :cancel_at_period_end, :boolean, :default => false
  end
end
