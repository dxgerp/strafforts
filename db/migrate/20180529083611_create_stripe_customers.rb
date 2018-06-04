class CreateStripeCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :stripe_customers, id: false do |t|
      t.string :id, primary_key: true
      t.integer :athlete_id
      t.string :email

      t.timestamps
    end
  end
end
