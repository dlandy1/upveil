class AddMaleToUser < ActiveRecord::Migration
  def change
    add_column :users, :male, :boolean, default: false
  end
end
