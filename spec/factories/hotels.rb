FactoryBot.define do
  factory :hotel do
  	name { Faker::StarWars.character }
    owner_id { Faker::Number.number(10) }
    rating { Faker::Number.number(10) }
    rate { Faker::Number.number(10) }
  end
end