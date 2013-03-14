class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.string :description

      t.timestamps
    end

    add_index :stories, :title, unique: true
  end
end
