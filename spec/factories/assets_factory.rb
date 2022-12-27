FactoryBot.define do
  factory :asset do
    code { Faker::Code.asin }
    issuer { Faker::Company.name }
    rate_index { Faker::Lorem.characters(number: 3) }
    entrance_rate { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
    quantity { Faker::Number.number(digits: 2) }
    volume_applied {  Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    application_date { Time.now - 1.hour }
    expiration_date { Time.now + 1.hour }
  end
end
