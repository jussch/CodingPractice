class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.string :album_type
      t.integer :band_id

      t.timestamp
    end
    add_index :albums, :band_id
  end
end
