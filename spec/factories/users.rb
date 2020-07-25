FactoryBot.define do
  factory :user do
    username { Faker::Name.unique.name }
    email { 'foo@bar.com' }
    password { 'foobar' }
    role { 'admin' 	}
  end
end