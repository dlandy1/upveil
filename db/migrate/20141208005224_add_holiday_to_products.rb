class AddHolidayToProducts < ActiveRecord::Migration
  def change
    add_column :products, :holiday, :boolean
  end
end
