require 'rails_helper'

RSpec.describe Simulation::CalculateAttributes do
  describe "call method" do
    let(:user) { create(:user) }
    let(:client) { create(:client, user:) }
    let(:asset) { create(:asset, client:) }

    let(:params) { attributes_for(:simulation) }

    let(:formatted_params) do
      {
        asset:,
        average_cdi: params[:average_cdi],
        market_rate: params[:market_rate],
        curve_volume: params[:curve_volume],
        new_asset_code: params[:new_asset_code],
        new_asset_issuer: params[:new_asset_issuer],
        entrance_rate: asset.entrance_rate,
        volume_applied: asset.volume_applied,
        market_redemption: params[:market_redemption],
        quotation_date: params[:quotation_date].to_datetime,
        new_asset_duration: params[:new_asset_duration],
        new_asset_minimum_rate: params[:new_asset_minimum_rate],
        new_asset_maximum_rate: params[:new_asset_maximum_rate],
        new_asset_suggested_rate: params[:new_asset_suggested_rate],
        new_asset_indicative_rate: params[:new_asset_indicative_rate],
        new_asset_expiration_date: params[:new_asset_expiration_date].to_datetime,
        current_asset_expiration_date: asset.expiration_date.to_datetime
      }
    end

    let(:attributes) { Simulation::CalculateAttributes.call(formatted_params:).result }

    it "return formated params" do
      reference_attributes = {
        average_cdi: formatted_params[:average_cdi],
        market_rate: formatted_params[:market_rate],
        curve_volume: formatted_params[:curve_volume],
        volume_applied: formatted_params[:volume_applied],
        new_asset_code: formatted_params[:new_asset_code],
        quotation_date: formatted_params[:quotation_date],
        new_asset_issuer: formatted_params[:new_asset_issuer],
        market_redemption: formatted_params[:market_redemption],
        new_asset_duration: formatted_params[:new_asset_duration],
        new_asset_minimum_rate: formatted_params[:new_asset_minimum_rate],
        new_asset_maximum_rate: formatted_params[:new_asset_maximum_rate],
        new_asset_suggested_rate: formatted_params[:new_asset_suggested_rate],
        new_asset_indicative_rate: formatted_params[:new_asset_indicative_rate],
        new_asset_expiration_date: formatted_params[:new_asset_expiration_date]
      }

      expect(attributes).to include(reference_attributes)
    end

    it "return agio" do
      agio = formatted_params[:market_redemption] - formatted_params[:curve_volume]

      expect(attributes).to include(agio:)
    end

    it "return agio_percentage" do
      agio_percentage = (formatted_params[:market_redemption] / formatted_params[:curve_volume]) - 1
  
      expect(attributes).to include(agio_percentage:)
    end
  
    it "return percentage_to_recover" do
      percentage_to_recover = (formatted_params[:curve_volume] / formatted_params[:market_redemption]) - 1
  
      expect(attributes).to include(percentage_to_recover:)
    end
  
    it "return days_in_years" do
      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
  
      expect(attributes).to include(days_in_years:)
    end
  
    it "return remaining_years" do
      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      remaining_years = ((formatted_params[:current_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
  
      expect(attributes).to include(remaining_years:)
    end
  
    it "return new_asset_remaining_years" do
      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      new_asset_remaining_years = ((formatted_params[:new_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
  
      expect(attributes).to include(new_asset_remaining_years:)
    end
  
    it "return current_final_value" do
      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      remaining_years = ((formatted_params[:current_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
      current_final_value = (formatted_params[:curve_volume] * ((1 + (formatted_params[:entrance_rate] * formatted_params[:average_cdi])) ** remaining_years)).to_f.round(4)
  
      expect(attributes).to include(current_final_value:)
    end
  
    it "return new_rate_final_value_same_period" do
      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      remaining_years = ((formatted_params[:current_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
      new_rate_final_value_same_period = (formatted_params[:market_redemption] * (((1 + formatted_params[:new_asset_suggested_rate]) * (1 + formatted_params[:average_cdi])) ** remaining_years)).to_f.round(4)
  
      expect(attributes).to include(new_rate_final_value_same_period:)
    end
  
    it "return variation_same_period" do
      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      remaining_years = ((formatted_params[:current_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
      new_rate_final_value_same_period = (formatted_params[:market_redemption] * (((1 + formatted_params[:new_asset_suggested_rate]) * (1 + formatted_params[:average_cdi])) ** remaining_years)).to_f.round(4)
      current_final_value = (formatted_params[:curve_volume] * ((1 + (formatted_params[:entrance_rate] * formatted_params[:average_cdi])) ** remaining_years)).to_f.round(4)

      variation_same_period = (new_rate_final_value_same_period - current_final_value).to_f.round(4)
  
      expect(attributes).to include(variation_same_period:)
    end
  
    it "return new_rate_final_value_new_period" do
      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      new_asset_remaining_years = ((formatted_params[:new_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
      new_rate_final_value_new_period = formatted_params[:market_redemption] * (((1 + formatted_params[:new_asset_suggested_rate]) * (1 + formatted_params[:average_cdi])) ** new_asset_remaining_years)
  
      expect(attributes).to include(new_rate_final_value_new_period:)
    end
  
    it "return final_variation" do
      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      new_asset_remaining_years = ((formatted_params[:new_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
      new_rate_final_value_new_period = formatted_params[:market_redemption] * (((1 + formatted_params[:new_asset_suggested_rate]) * (1 + formatted_params[:average_cdi])) ** new_asset_remaining_years)

      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      remaining_years = ((formatted_params[:current_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
      current_final_value = (formatted_params[:curve_volume] * ((1 + (formatted_params[:entrance_rate] * formatted_params[:average_cdi])) ** remaining_years)).to_f.round(4)

      final_variation = (new_rate_final_value_new_period - current_final_value).to_f.round(4)
  
      expect(attributes).to include(final_variation:)
    end
  
    it "return is_worth" do
      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      remaining_years = ((formatted_params[:current_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
      new_rate_final_value_same_period = (formatted_params[:market_redemption] * (((1 + formatted_params[:new_asset_suggested_rate]) * (1 + formatted_params[:average_cdi])) ** remaining_years)).to_f.round(4)
      current_final_value = (formatted_params[:curve_volume] * ((1 + (formatted_params[:entrance_rate] * formatted_params[:average_cdi])) ** remaining_years)).to_f.round(4)

      variation_same_period = (new_rate_final_value_same_period - current_final_value).to_f.round(4)

      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      new_asset_remaining_years = ((formatted_params[:new_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
      new_rate_final_value_new_period = formatted_params[:market_redemption] * (((1 + formatted_params[:new_asset_suggested_rate]) * (1 + formatted_params[:average_cdi])) ** new_asset_remaining_years)

      days_in_years = (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
      remaining_years = ((formatted_params[:current_asset_expiration_date] - formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
      current_final_value = (formatted_params[:curve_volume] * ((1 + (formatted_params[:entrance_rate] * formatted_params[:average_cdi])) ** remaining_years)).to_f.round(4)

      final_variation = (new_rate_final_value_new_period - current_final_value).to_f.round(4)

      is_worth = variation_same_period > 0 && final_variation > 0
  
      expect(attributes).to include(is_worth:)
    end
  end
end
