class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.integer :hotel_id
      t.integer :user_id
      t.boolean :payment_status, default: false
      t.string :booking_class

      t.timestamps
    end
  end
end
