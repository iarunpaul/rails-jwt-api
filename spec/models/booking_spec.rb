# spec/models/booking_spec.rb
require 'rails_helper'

# Test suite for the Booking model
RSpec.describe Booking, type: :model do
  # Association test
  # ensure an booking record belongs to a single hotel record
  # ensure an booking record belongs to a single user record
  it { should belong_to(:hotel) }
  it { should belong_to(:user) }
  # Validation test
  # ensure column hotel_id and user_id is present before saving
  it { should validate_presence_of(:hotel_id) }
  it { should validate_presence_of(:user_id) }
  it { should define_enum_for(:booking_status).with([:cancelled, :pending, :confirmed]) }
end