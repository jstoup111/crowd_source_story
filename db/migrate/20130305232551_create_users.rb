class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :username
      t.string :remember
      t.string :password_digest
      t.string :confirmation

      t.timestamps
    end

    add_index :users, :email,     unique: true
    add_index :users, :username,  unique: true
  end
end
