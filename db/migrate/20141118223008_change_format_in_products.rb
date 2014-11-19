class ChangeFormatInProducts < ActiveRecord::Migration
  def change
    change_column :products, :description, :text
    change_column :products, :link, :text
  end
end
