class AddSecretToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :secret, :boolean, default: false
  end
end
