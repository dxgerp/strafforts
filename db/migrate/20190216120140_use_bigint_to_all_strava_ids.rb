class UseBigintToAllStravaIds < ActiveRecord::Migration[5.2]
  def change
    change_column :activities, :id,:bigint
    change_column :athletes, :last_activity_retrieved,:bigint
    change_column :best_efforts, :activity_id,:bigint
    change_column :races, :activity_id,:bigint
  end
end
