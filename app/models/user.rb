class User < ApplicationRecord
	has_secure_password
	validates :username, presence: true, uniqueness: true
	validates :password, length: { in: 6..20 }
	enum role: { admin: 0, owner: 1, customer: 2 }

	has_many :bookings
	has_many :hotels, through: :bookings

	def initialize(*)
    	super
  	rescue ArgumentError
    	render json: {error: "Role error."}
  	end

end
