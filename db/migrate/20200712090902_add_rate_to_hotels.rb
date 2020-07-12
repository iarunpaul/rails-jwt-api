class AddRateToHotels < ActiveRecord::Migration[6.0]
  def change
  	add_column :hotels, :rate, :decimal
  	rename_column :hotels, :hotel_class, :rating
  	change_column :hotels, :rating, :integer
  end
end
