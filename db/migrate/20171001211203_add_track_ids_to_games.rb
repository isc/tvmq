class AddTrackIdsToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :track_ids, :integer, array: true, default: []
  end
end
