class Booking < ApplicationRecord
	belongs_to :user
	belongs_to :hotel
	enum booking_status: { cancelled: 0, pending: 1, confirmed: 2 }
end
