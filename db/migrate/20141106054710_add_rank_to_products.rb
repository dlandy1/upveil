class AddRankToProducts < ActiveRecord::Migration
  def change
    add_column :products, :rank, :float
  end
end
