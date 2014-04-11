class CreateTeeTimes < ActiveRecord::Migration
  def change
    create_table :tee_times do |t|
      t.datetime :booking_time

      t.timestamps
    end
  end
end
