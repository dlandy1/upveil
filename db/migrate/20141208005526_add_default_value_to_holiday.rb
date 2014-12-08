class AddDefaultValueToHoliday < ActiveRecord::Migration
  def change
     change_column :products, :holiday, :boolean, default: false
  end
end
