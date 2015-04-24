class AddBothToUser < ActiveRecord::Migration
  def change
    add_column :users, :both, :boolean, default: false
  end
end
