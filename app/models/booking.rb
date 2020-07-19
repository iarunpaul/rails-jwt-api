class Booking < ApplicationRecord
	belongs_to :user
	belongs_to :hotel
	validates :hotel_id, :user_id, presence: true
	enum booking_status: { cancelled: 0, pending: 1, confirmed: 2 }
end
