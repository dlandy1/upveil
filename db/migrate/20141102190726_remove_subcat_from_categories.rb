class RemoveSubcatFromCategories < ActiveRecord::Migration
  def change
    remove_reference :categories, :subcat, index: true
  end
end
