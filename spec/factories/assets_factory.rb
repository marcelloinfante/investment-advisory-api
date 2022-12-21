FactoryBot.define do
  factory :asset do
    code { Faker::Code.asin }
    issuer { Faker::Company.name }
    rate_index { "MyString" }
    entrace_rate { "9.99" }
    quantity { 1 }
    application_date { "2022-12-21 00:24:31" }
    expiration_date { "2022-12-21 00:24:31" }
  end
end
