class AddPasswordDigestToUsers < ActiveRecord::Migration
  def up
    add_column :users, :password_digest, :string
    remove_column :users, :password_salt
    remove_column :users, :password_hash
  end

  def down
    remove_column :users, :password_digest
    add_column :users, :password_salt, :string
    add_column :users, :password_hash, :string
  end
end
