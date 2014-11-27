class AddPurchaseToProducts < ActiveRecord::Migration
  def change
    add_column :products, :purchase, :boolean, default: false
  end
end
