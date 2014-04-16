class AddClubIdToTeeTimes < ActiveRecord::Migration
  def change
    add_column :tee_times, :club_id, :integer
  end
end
