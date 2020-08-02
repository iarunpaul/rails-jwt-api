class HotelSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :name, :owner_id, :created_at, :updated_at
  # model association
  has_many :bookings
end
