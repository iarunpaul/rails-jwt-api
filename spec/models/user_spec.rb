require 'rails_helper'

# Test suite for User model
RSpec.describe User, type: :model do
  # Association test
  # ensure User model has a 1:m relationship with the Todo model
  it { should have_many(:bookings) }
  it { should have_many(:hotels).through(:bookings) }
  # Validation tests
  # ensure name, email and password_digest are present before save
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:password) }
	it { should validate_length_of(:password).is_at_least(6)}
	it { should define_enum_for(:role).with([:admin, :owner, :customer]) }
end