class AddSubcatToCategories < ActiveRecord::Migration
  def change
    add_reference :categories, :subcat, index: true
  end
end
