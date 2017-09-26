class AddCurrentTrackToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :current_track_id, :integer
  end
end
