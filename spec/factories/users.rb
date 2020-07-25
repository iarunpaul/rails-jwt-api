FactoryBot.define do
  factory :user do
    username { Faker::Name.unique.name }
    email { 'foo@bar.com' }
    password { 'foobar' }
  end
end