class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.jsonb :data

      t.timestamps
    end
  end
end
