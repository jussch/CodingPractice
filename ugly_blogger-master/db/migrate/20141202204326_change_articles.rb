class ChangeArticles < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.string :title
      t.text :body
    end
  end
end
