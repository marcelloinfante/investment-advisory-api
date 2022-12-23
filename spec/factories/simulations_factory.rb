FactoryBot.define do
  factory :simulation do
    is_worth { true }
    quotation_date { Time.now }
    new_asset_code { Faker::Code.asin }
    new_asset_issuer { Faker::Company.name }
    agio { Faker::Number.number(digits: 2) }
    new_asset_expiration_date { Time.now + 1.hour }
    curve_volume { Faker::Number.number(digits: 2) }
    days_in_years { Faker::Number.number(digits: 2) }
    volume_applied { Faker::Number.number(digits: 2) }
    market_redemption { Faker::Number.number(digits: 2) }
    new_asset_duration { Faker::Number.number(digits: 2) }
    market_rate { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    average_cdi { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    new_asset_remaining_years{ Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    agio_percentage { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    final_variation { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    remaining_years { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    current_final_value { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    variation_same_period { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    percentage_to_recover { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    new_asset_minimum_rate { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    new_asset_maximum_rate { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    new_asset_suggested_rate { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    new_asset_indicative_rate { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    new_rate_final_value_same_period { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    new_rate_final_value_new_period { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
