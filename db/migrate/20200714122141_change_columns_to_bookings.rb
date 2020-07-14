class ChangeColumnsToBookings < ActiveRecord::Migration[6.0]
  def change
  	change_column :bookings, :hotel_id, :integer, null: false
  	change_column :bookings, :user_id, :integer, null: false
  end
end
