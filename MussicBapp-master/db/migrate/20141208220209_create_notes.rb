class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.integer :track_id
      t.text :body

      t.timestamps
    end
    add_index :notes, :user_id
    add_index :notes, :track_id
  end
end
