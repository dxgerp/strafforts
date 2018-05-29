class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :athlete_id
      t.uuid :subscription_plan_id

      t.timestamps
      t.datetime :starts_at
      t.datetime :expires_at
      t.boolean :is_deleted, :default => false
    end
  end
end
