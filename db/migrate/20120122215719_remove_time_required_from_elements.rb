class RemoveTimeRequiredFromElements < ActiveRecord::Migration
  def up
    remove_column :elements, :time_required
  end

  def down
    add_column :elements, :time_required, :integer
  end
end
