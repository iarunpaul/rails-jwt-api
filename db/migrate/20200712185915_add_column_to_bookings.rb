class AddColumnToBookings < ActiveRecord::Migration[6.0]
  def change
  	add_column :bookings, :booking_status, :integer, default: 1, null: false
  end
end
