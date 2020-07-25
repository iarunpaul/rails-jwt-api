
# spec/factories/bookings.rb
FactoryBot.define do
  factory :booking do
    hotel_id { Faker::Number.number(digits: 10) }
    user_id { Faker::Number.number(digits: 10) }
    payment_status { false }
    booking_status { 1 }
    adults { 1 }
    children { nil }
  end
end