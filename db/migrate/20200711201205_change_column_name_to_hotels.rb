class ChangeColumnNameToHotels < ActiveRecord::Migration[6.0]
  def change
  	rename_column :hotels, :class, :hotel_class
  end
end
