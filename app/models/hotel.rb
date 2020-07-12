class Hotel < ApplicationRecord
	validates :name, :rate, :rating, presence: true

	has_many :bookings
	has_many :users, through: :bookings
end
