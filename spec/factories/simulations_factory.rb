FactoryBot.define do
  factory :simulation do
    is_worth { Faker::Boolean.boolean(true_ratio: 0.6) }
    quotation_date { Time.now }
    new_asset_code { Faker::Code.asin }
    new_asset_issuer { Faker::Company.name }
    agio { Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    new_asset_expiration_date { Time.now + 1.hour }
    curve_volume { Faker::Number.decimal(l_digits: 7, r_digits: 2) }
    days_in_years { 365 }
    market_redemption { Faker::Number.decimal(l_digits: 7, r_digits: 2) }
    new_asset_duration { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    market_rate { Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    average_cdi { Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    new_asset_remaining_years{ Faker::Number.decimal(l_digits: 2, r_digits: 1) }
    agio_percentage { Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    final_variation { Faker::Number.decimal(l_digits: 6, r_digits: 2) }
    remaining_years { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    current_final_value { Faker::Number.decimal(l_digits: 6, r_digits: 2) }
    variation_same_period { Faker::Number.decimal(l_digits: 6, r_digits: 2) }
    percentage_to_recover { Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    new_asset_minimum_rate { Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    new_asset_maximum_rate { Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    new_asset_suggested_rate { Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    new_asset_indicative_rate { Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    relative_final_variation {  Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    relative_variation_same_period {  Faker::Number.decimal(l_digits: 0, r_digits: 4) }
    new_rate_final_value_same_period { Faker::Number.decimal(l_digits: 7, r_digits: 2) }
    new_rate_final_value_new_period { Faker::Number.decimal(l_digits: 7, r_digits: 2) }
  end
end
