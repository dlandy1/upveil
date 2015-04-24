class RemoveMaleFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :male, :boolean
  end
end
