class AddArtistFoundAndTrackFoundToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :artist_found, :boolean, null: false, default: false
    add_column :games, :track_found, :boolean, null: false, default: false
  end
end
