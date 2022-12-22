class Simulation < ApplicationRecord
  include Discard::Model

  belongs_to :asset

  validates :agio, presence: true
  validates :is_worth, presence: true
  validates :market_rate, presence: true
  validates :average_cdi, presence: true
  validates :curve_volume, presence: true
  validates :days_in_years, presence: true
  validates :new_asset_code, presence: true
  validates :new_asset_issuer, presence: true
  validates :volume_applied, presence: true
  validates :quotation_date, presence: true
  validates :years_to_expire, presence: true
  validates :agio_percentage, presence: true
  validates :final_variation, presence: true
  validates :remaining_mounths, presence: true
  validates :market_redemption, presence: true
  validates :current_final_value, presence: true
  validates :current_final_value, presence: true
  validates :new_asset_duration, presence: true
  validates :percentage_to_recover, presence: true
  validates :new_asset_minimum_rate, presence: true
  validates :new_asset_maximum_rate, presence: true
  validates :new_asset_suggested_rate, presence: true
  validates :new_asset_indicative_rate, presence: true
  validates :new_asset_expiration_date, presence: true
  validates :year_to_expire_with_new_rate, presence: true
  validates :new_rate_final_value_same_period, presence: true
  validates :final_value_with_new_rate_at_new_period, presence: true
end
