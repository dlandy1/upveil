class ChangeStuffFromProducts < ActiveRecord::Migration
  def change
    change_column :products, :description, :text, :limit => nil
    change_column :products, :link, :text, :limit => nil
  end
end
