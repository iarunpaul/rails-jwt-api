class ChangeAdultsToBookings < ActiveRecord::Migration[6.0]
  def change
  	change_column :bookings, :adults, :integer, default: 1
  end
end
