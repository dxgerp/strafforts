class UseBigIntOnActivityId < ActiveRecord::Migration[5.2]
  def change
    change_column :activities, :id,'bigint'
  end
end
