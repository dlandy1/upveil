class AddChildToProducts < ActiveRecord::Migration
  def change
    add_column :products, :grandcat_id, :integer
  end
end
