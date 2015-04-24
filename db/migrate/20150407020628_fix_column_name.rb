class FixColumnName < ActiveRecord::Migration
  def change
     rename_column :follows, :Gender, :gender
  end
end
