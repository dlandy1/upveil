class AddGenderToFollow < ActiveRecord::Migration
  def change
    add_column :follows, :Gender, :string
  end
end
