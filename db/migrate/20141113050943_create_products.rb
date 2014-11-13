class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.integer :user_id
      t.integer :category_id
      t.integer :price
      t.string :link
      t.string :description
      t.string :image
      t.integer :subcat_id
      t.float :rank
      t.string :gender

      t.timestamps
    end
    add_index :products, :user_id
    add_index :products, :category_id
    add_index :products, :subcat_id
  end
end
