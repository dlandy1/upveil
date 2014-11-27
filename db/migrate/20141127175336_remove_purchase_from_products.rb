class RemovePurchaseFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :purchase, :boolean
  end
end
