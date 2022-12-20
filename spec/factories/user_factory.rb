FactoryBot.define do
  factory :user do
    transient do
      password_value { Faker::Internet.password }
    end

    company
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    email  { Faker::Internet.unique.email }
    password { password_value }
    password_confirmation { password_value }
  end
end