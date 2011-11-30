class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements, :id => false do |t|
      t.column :id, 'char(36) binary', :null => false, :primary => true
      t.column :user_id, 'char(36) binary', :null => false
      t.column :parent_id, 'char(36) binary'
      t.string :title
      t.datetime :starts_at
      t.datetime :due_at
      t.datetime :done_at
      t.integer :time_required
      t.integer :value
      t.integer :urgency
      t.integer :times_done

      t.timestamps
    end

    add_index :elements, :id, :unique => true
    add_index :elements, :user_id
    add_index :elements, :parent_id
  end
end
