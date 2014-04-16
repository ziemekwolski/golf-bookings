class AddUserIdToTeeTimes < ActiveRecord::Migration
  def change
    add_column :tee_times, :user_id, :integer
  end
end
