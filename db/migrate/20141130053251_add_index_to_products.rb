class AddIndexToProducts < ActiveRecord::Migration
  def change
    add_index :products, :grandcat_id
  end
end
