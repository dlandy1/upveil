class ChangeFormatelInProducts < ActiveRecord::Migration
  def change
    change_column :products, :description, :string, :limit => nil
    change_column :products, :link, :string, :limit => nil
  end
end
