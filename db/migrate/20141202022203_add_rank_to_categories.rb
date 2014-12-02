class AddRankToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :rank, :float
  end
end
