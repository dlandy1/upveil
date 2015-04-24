class AddFemaleToUser < ActiveRecord::Migration
  def change
    add_column :users, :female, :boolean, default: false
  end
end
