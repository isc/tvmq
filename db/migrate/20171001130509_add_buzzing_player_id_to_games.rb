class AddBuzzingPlayerIdToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :buzzing_player_id, :integer
  end
end
