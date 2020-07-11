class User < ApplicationRecord
	has_secure_password
	enum role: { admin: 0, owner: 1, customer: 2 }
end
