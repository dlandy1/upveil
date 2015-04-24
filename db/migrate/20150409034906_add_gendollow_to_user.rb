class AddGendollowToUser < ActiveRecord::Migration
  def change
    add_column :users, :gendollow, :string
  end
end
