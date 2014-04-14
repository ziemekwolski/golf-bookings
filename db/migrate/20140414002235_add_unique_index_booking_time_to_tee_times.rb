class AddUniqueIndexBookingTimeToTeeTimes < ActiveRecord::Migration
  def change
    add_index :tee_times, :booking_time, unique: true
  end
end
