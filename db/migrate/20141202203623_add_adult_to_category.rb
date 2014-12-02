class AddAdultToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :adult, :boolean, default: false
  end
end
