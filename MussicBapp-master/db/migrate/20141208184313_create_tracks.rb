class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :track_type
      t.integer :album_id
      t.text :lyrics

      t.timestamps
    end
    add_index :tracks, :album_id
  end
end
