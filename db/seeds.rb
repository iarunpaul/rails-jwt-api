# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(username: "admin", password: "password", email: "user@example.com", role: 0)
# user2 = User.create(username: "owner", password: "password", email: "user@example.com", role: 1)
# user3 = User.create(username: "customer", password: "password", email: "user@example.com", role: 2)
# user4 = User.create(username: "customer2", password: "password", email: "user@example.com", role: 1)
# hotel1 = Hotel.create(name: "SunMoon", rating: 3, rate: 1000, description: "The best class hotel in town!", owner_id: user2.id)
# hotel2 = Hotel.create(name: "MoonSun", rating: 3, rate: 1000, description: "The best class hotel in town!", owner_id: user2.id)
# booking1 = Booking.create(user_id: user3.id, hotel_id: hotel1.id, adults: 3, children: 1)
# booking2 = Booking.create(user_id: user4.id, hotel_id: hotel1.id, adults: 3, children: 1)
# booking3 = Booking.create(user_id: user1.id, hotel_id: hotel1.id, adults: 3, children: 1)
# booking1 = Booking.create(user_id: user3.id, hotel_id: hotel2.id, adults: 3, children: 1)
# booking2 = Booking.create(user_id: user4.id, hotel_id: hotel2.id, adults: 3, children: 1)
# booking3 = Booking.create(user_id: user1.id, hotel_id: hotel2.id, adults: 3, children: 1)
# booking = Booking.create(hotel_id: hotel.id, user_id: user3.id, booking_class: hotel.hotel_class)