class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.integer :user_id
      t.integer :category_id

      t.timestamps
    end
    add_index :products, :user_id
    add_index :products, :category_id
  end
end
