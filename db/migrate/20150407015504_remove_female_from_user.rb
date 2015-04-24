class RemoveFemaleFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :female, :boolean
  end
end
