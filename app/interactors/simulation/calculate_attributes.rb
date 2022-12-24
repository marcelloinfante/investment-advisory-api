class Simulation::CalculateAttributes
  include Interactor

  def call
    context.result = {
      agio:,
      is_worth:,
      remaining_years:,
      days_in_years:,
      final_variation:,
      agio_percentage:,
      current_final_value:,
      percentage_to_recover:,
      variation_same_period:,
      new_asset_remaining_years:,
      new_rate_final_value_new_period:,
      new_rate_final_value_same_period:,
      average_cdi: context.formatted_params[:average_cdi],
      market_rate: context.formatted_params[:market_rate],
      curve_volume: context.formatted_params[:curve_volume],
      volume_applied: context.formatted_params[:volume_applied],
      new_asset_code: context.formatted_params[:new_asset_code],
      quotation_date: context.formatted_params[:quotation_date],
      new_asset_issuer: context.formatted_params[:new_asset_issuer],
      market_redemption: context.formatted_params[:market_redemption],
      new_asset_duration: context.formatted_params[:new_asset_duration],
      new_asset_minimum_rate: context.formatted_params[:new_asset_minimum_rate],
      new_asset_maximum_rate: context.formatted_params[:new_asset_maximum_rate],
      new_asset_suggested_rate: context.formatted_params[:new_asset_suggested_rate],
      new_asset_indicative_rate: context.formatted_params[:new_asset_indicative_rate],
      new_asset_expiration_date: context.formatted_params[:new_asset_expiration_date]
    }
  end

  private

  def agio
    context.formatted_params[:market_redemption] - context.formatted_params[:curve_volume]
  end

  def agio_percentage
    (context.formatted_params[:market_redemption] / context.formatted_params[:curve_volume]) - 1
  end

  def percentage_to_recover
    (context.formatted_params[:curve_volume] / context.formatted_params[:market_redemption]) - 1
  end

  def days_in_years
    (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
  end

  def remaining_years
    ((context.formatted_params[:current_asset_expiration_date] - context.formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
  end

  def new_asset_remaining_years
    ((context.formatted_params[:new_asset_expiration_date] - context.formatted_params[:quotation_date]) / days_in_years).to_f.round(4)
  end

  def current_final_value
    (context.formatted_params[:curve_volume] * ((1 + (context.formatted_params[:entrance_rate] * context.formatted_params[:average_cdi])) ** remaining_years)).to_f.round(4)
  end

  def new_rate_final_value_same_period
    (context.formatted_params[:market_redemption] * (((1 + context.formatted_params[:new_asset_suggested_rate]) * (1 + context.formatted_params[:average_cdi])) ** remaining_years)).to_f.round(4)
  end

  def variation_same_period
    (new_rate_final_value_same_period - current_final_value).to_f.round(4)
  end

  def new_rate_final_value_new_period
    context.formatted_params[:market_redemption] * (((1 + context.formatted_params[:new_asset_suggested_rate]) * (1 + context.formatted_params[:average_cdi])) ** new_asset_remaining_years)
  end

  def final_variation
    (new_rate_final_value_new_period - current_final_value).to_f.round(4)
  end

  def is_worth
    variation_same_period > 0 && final_variation > 0
  end
end