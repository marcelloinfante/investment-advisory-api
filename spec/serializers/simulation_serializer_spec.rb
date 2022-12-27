require "rails_helper"

RSpec.describe SimulationSerializer do
  context "serialized hash" do
    it "return serialized simulation" do
      user = create(:user)
      client = create(:client, user:)
      asset = create(:asset, client:)
      simulation = create(:simulation, asset:)

      serialized_simulation = SimulationSerializer.new(simulation).sanitized_hash

      expect(serialized_simulation).to include({
        id: simulation.id,
        agio: simulation.agio,
        is_worth: simulation.is_worth,
        market_rate: simulation.market_rate,
        average_cdi: simulation.average_cdi,
        curve_volume: simulation.curve_volume,
        days_in_years: simulation.days_in_years,
        new_asset_code: simulation.new_asset_code,
        new_asset_issuer: simulation.new_asset_issuer,
        quotation_date: simulation.quotation_date,
        agio_percentage: simulation.agio_percentage,
        final_variation: simulation.final_variation,
        remaining_years: simulation.remaining_years,
        market_redemption: simulation.market_redemption,
        current_final_value: simulation.current_final_value,
        current_final_value: simulation.current_final_value,
        new_asset_duration: simulation.new_asset_duration,
        percentage_to_recover: simulation.percentage_to_recover,
        new_asset_minimum_rate: simulation.new_asset_minimum_rate,
        new_asset_maximum_rate: simulation.new_asset_maximum_rate,
        new_asset_suggested_rate: simulation.new_asset_suggested_rate,
        new_asset_remaining_years: simulation.new_asset_remaining_years,
        new_asset_indicative_rate: simulation.new_asset_indicative_rate,
        new_asset_expiration_date: simulation.new_asset_expiration_date,
        new_rate_final_value_same_period: simulation.new_rate_final_value_same_period,
        new_rate_final_value_new_period: simulation.new_rate_final_value_new_period
      })
    end
  end
end