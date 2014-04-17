class AddDefaultGolfClub < ActiveRecord::Migration
  def up
    execute "INSERT INTO clubs (name, created_at, updated_at) values('default', now(), now())"
    execute "UPDATE tee_times set club_id = (SELECT id FROM clubs order by id desc limit 1) where club_id is null"
  end

  def down
    #no down,data will be deleted anyways.
  end
end
