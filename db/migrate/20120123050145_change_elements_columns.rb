class ChangeElementsColumns < ActiveRecord::Migration
  def up
    change_column :elements, :value, :integer, :null => false, :default => 0
    change_column :elements, :urgency, :integer, :null => false, :default => 0
  end

  def down
    change_column :elements, :value, :integer
    change_column :elements, :urgency, :integer
  end
end
