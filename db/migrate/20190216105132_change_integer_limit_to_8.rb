class ChangeIntegerLimitTo8 < ActiveRecord::Migration[5.2]
  def change
    change_column :activities, :id,'bigint', limit: 8
    change_column :best_efforts, :id,'bigint', limit: 8
    change_column :athletes, :id,'bigint', limit: 8
  end
end
