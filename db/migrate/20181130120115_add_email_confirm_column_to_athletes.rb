class AddEmailConfirmColumnToAthletes < ActiveRecord::Migration[5.1]
  def change
    add_column :athletes, :email_confirmed, :boolean, :default => false
    add_column :athletes, :confirmation_token, :string
    add_column :athletes, :confirmation_sent_at, :datetime
    add_column :athletes, :confirmed_at, :datetime

    add_index :athletes, :confirmation_token, :unique => true

    Athlete.update_all(email_confirmed: true)
    Athlete.update_all(confirmed_at: DateTime.now.utc.to_date)
  end
end
