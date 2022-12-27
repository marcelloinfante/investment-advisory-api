require 'rails_helper'

RSpec.describe Simulation::FormatAttributes do
  describe "method call" do
    it "return formatted params" do
      user = create(:user)
      client = create(:client, user:)
      asset = create(:asset, client:)
      simulation_params = attributes_for(:simulation, asset:)

      params = {
        asset: simulation_params[:asset],
        average_cdi: simulation_params[:average_cdi].to_s,
        market_rate: simulation_params[:market_rate].to_s,
        curve_volume: simulation_params[:curve_volume].to_s,
        new_asset_code: simulation_params[:new_asset_code],
        new_asset_issuer: simulation_params[:new_asset_issuer],
        quotation_date: simulation_params[:quotation_date].to_s,
        market_redemption: simulation_params[:market_redemption].to_s,
        new_asset_duration: simulation_params[:new_asset_duration].to_s,
        new_asset_minimum_rate: simulation_params[:new_asset_minimum_rate].to_s,
        new_asset_maximum_rate: simulation_params[:new_asset_maximum_rate].to_s,
        new_asset_suggested_rate: simulation_params[:new_asset_suggested_rate].to_s,
        new_asset_indicative_rate: simulation_params[:new_asset_indicative_rate].to_s,
        new_asset_expiration_date: simulation_params[:new_asset_expiration_date].to_s,
      }

      formatted_params = Simulation::FormatAttributes.call(params:).formatted_params

      reference_params = {
        asset: params[:asset],
        average_cdi: params[:average_cdi].to_f,
        market_rate: params[:market_rate].to_f,
        curve_volume: params[:curve_volume].to_i,
        new_asset_code: params[:new_asset_code],
        new_asset_issuer: params[:new_asset_issuer],
        entrance_rate: params[:asset].entrance_rate,
        volume_applied: params[:asset].volume_applied.to_i,
        market_redemption: params[:market_redemption].to_i,
        quotation_date: Date.parse(params[:quotation_date]),
        new_asset_duration: params[:new_asset_duration].to_i,
        new_asset_minimum_rate: params[:new_asset_minimum_rate].to_f,
        new_asset_maximum_rate: params[:new_asset_maximum_rate].to_f,
        new_asset_suggested_rate: params[:new_asset_suggested_rate].to_f,
        new_asset_indicative_rate: params[:new_asset_indicative_rate].to_f,
        new_asset_expiration_date: Date.parse(params[:new_asset_expiration_date]),
        current_asset_expiration_date: params[:asset].expiration_date.to_datetime
      }

      expect(formatted_params).to include(reference_params)
    end
  end
end