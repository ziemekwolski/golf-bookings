class ChangeIndexTeeTimes < ActiveRecord::Migration
  def change
    remove_index :tee_times, :booking_time
    add_index :tee_times, [:booking_time, :club_id], unique: true
  end
end
