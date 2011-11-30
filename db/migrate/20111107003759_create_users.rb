class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id => false do |t|
      t.column :id, 'char(36) binary', :null => false, :primary => true
      t.string :email
      t.string :username
      t.string :password_hash
      t.string :password_salt

      t.timestamps
    end

    add_index :users, :id, :unique => true
    add_index :users, :email
    add_index :users, :username
  end
end
