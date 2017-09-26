class AddScoreToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :score, :integer, default: 0, null: false
  end
end
