class CreateStorySnippets < ActiveRecord::Migration
  def change
    create_table :story_snippets do |t|
      t.text :content
      t.references :user
      t.references :story

      t.timestamps
    end
    add_index :story_snippets, :user_id
    add_index :story_snippets, :story_id
  end
end
