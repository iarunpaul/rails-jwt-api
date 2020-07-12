class RemoveBookingClassFromBookings < ActiveRecord::Migration[6.0]
  def change
  	remove_column :bookings, :booking_class
  end
end
