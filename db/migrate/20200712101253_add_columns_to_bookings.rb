class AddColumnsToBookings < ActiveRecord::Migration[6.0]
  def change
  	add_column :bookings, :adults, :integer
  	add_column :bookings, :children, :integer
  	add_column :bookings, :rate, :decimal
  	add_column :bookings, :amount, :decimal
  end
end
