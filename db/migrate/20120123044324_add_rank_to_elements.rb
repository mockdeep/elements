class AddRankToElements < ActiveRecord::Migration
  def change
    add_column :elements, :rank, :integer
    add_index :elements, :rank
  end
end
