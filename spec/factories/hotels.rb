FactoryBot.define do
  factory :hotel do
  	name { Faker::Name.name }
    owner_id { Faker::Number.number(digits: 10) }
    rating { Faker::Number.number(digits: 10) }
    rate { Faker::Number.number(digits: 10) }
  end
end