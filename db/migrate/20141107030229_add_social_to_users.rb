class AddSocialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_url, :string
    add_column :users, :instagram_url, :string
  end
end
