class AddRefreshTokenAndExpiresAtToAthletes < ActiveRecord::Migration[5.1]
  def change
    add_column :athletes, :refresh_token, :string
    add_column :athletes, :refresh_token_expires_at, :datetime
  end
end
