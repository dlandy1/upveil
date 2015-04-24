class RemoveBothFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :both, :boolean
  end
end
