class Hotel < ApplicationRecord
	validates :name, :rate, :rating, :owner_id, presence: true

	has_many :bookings
	has_many :users, through: :bookings
end
