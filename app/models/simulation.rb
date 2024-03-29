class Simulation < ApplicationRecord
  include Discard::Model

  belongs_to :asset

  validates :agio, presence: true
  validates :market_rate, presence: true
  validates :average_cdi, presence: true
  validates :curve_volume, presence: true
  validates :days_in_years, presence: true
  validates :new_asset_code, presence: true
  validates :new_asset_issuer, presence: true
  validates :quotation_date, presence: true
  validates :new_asset_remaining_years, presence: true
  validates :agio_percentage, presence: true
  validates :final_variation, presence: true
  validates :remaining_years, presence: true
  validates :market_redemption, presence: true
  validates :current_final_value, presence: true
  validates :current_final_value, presence: true
  validates :new_asset_duration, presence: true
  validates :percentage_to_recover, presence: true
  validates :variation_same_period, presence: true
  validates :new_asset_minimum_rate, presence: true
  validates :new_asset_maximum_rate, presence: true
  validates :new_asset_suggested_rate, presence: true
  validates :new_asset_indicative_rate, presence: true
  validates :new_asset_expiration_date, presence: true
  validates :relative_final_variation, presence: true
  validates :relative_variation_same_period, presence: true
  validates :new_rate_final_value_same_period, presence: true
  validates :new_rate_final_value_new_period, presence: true
end
