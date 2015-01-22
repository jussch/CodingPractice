class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name

      t.timestamp
    end
  end
end
