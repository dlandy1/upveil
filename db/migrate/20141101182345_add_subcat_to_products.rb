class AddSubcatToProducts < ActiveRecord::Migration
  def change
    add_column :products, :subcat_id, :integer
  end
end
