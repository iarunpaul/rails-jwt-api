# spec/models/hotel_spec.rb
require 'rails_helper'

# Test suite for the Hotel model
RSpec.describe Hotel, type: :model do
  # Association test
  # ensure Hotel model has a 1:m relationship with the Item model
  it { should have_many(:users) }
  it { should have_many(:bookings) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:rate) }
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:owner_id) }
end