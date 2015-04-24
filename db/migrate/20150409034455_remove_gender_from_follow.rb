class RemoveGenderFromFollow < ActiveRecord::Migration
  def change
    remove_column :follows, :gender, :string
  end
end
