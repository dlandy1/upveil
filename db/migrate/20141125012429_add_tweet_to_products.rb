class AddTweetToProducts < ActiveRecord::Migration
  def change
    add_column :products, :tweet, :boolean, default: false
  end
end
