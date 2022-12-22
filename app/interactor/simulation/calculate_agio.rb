class Simulation::CalculateAttributes
  include Interactor

  def call
    return {
      agio:,
      is_worth:,
      days_in_years:,
      final_variation:,
      agio_percentage:,
      remaining_mounths:,
      current_final_value:,
      percentage_to_recover:,
      variation_same_period:,
      years_to_expire_with_new_rate:,
      new_rate_final_value_new_period:,
      new_rate_final_value_same_period:,
      average_cdi: context.average_cdi,
      market_rate: context.market_rate,
      curve_volume: context.curve_volume,
      volume_applied: context.volume_applied,
      new_asset_code: context.new_asset_code,
      quotation_date: context.quotation_date,
      years_to_expire: context.years_to_expire,
      new_asset_issuer: context.new_asset_issuer,
      market_redemption: context.market_redemption,
      new_asset_duration: context.new_asset_duration,
      new_asset_minimum_rate: context.new_asset_minimum_rate,
      new_asset_maximum_rate: context.new_asset_maximum_rate,
      new_asset_suggested_rate: context.new_asset_suggested_rate,
      new_asset_expiration_date: context.new_asset_expiration_date,
      new_asset_indicative_rate: context.new_asset_indicative_rate
    }
  end

  private

  def agio
    context.market_redemption - context.curve_volume
  end

  def agio_percentage
    (context.market_redemption / context.curve_volume) - 1
  end

  def percentage_to_recover
    (context.curve_volume / context.market_redemption) - 1
  end

  def days_in_years
    (Date.today.beginning_of_year.next_year - Date.today.beginning_of_year).to_i
  end

  def years_to_expire_with_new_rate
    (context.asset[:expiration_date] - context.quotation_date) / days_in_years
  end

  def remaining_mounths
    (context.new_asset_expiration_date - context.quotation_date) / days_in_years
  end

  def current_final_value
    context.curve_volume * ((1 + (context.entrance_rate * context.average_cdi)) ** context.remaing_years)
  end

  def new_rate_final_value_same_period
    context.market_redemption * (((1 + context.new_asset_sugested_rate) * (1 + context.average_cdi)) ** context.remaing_years)
  end

  def variation_same_period
    new_rate_final_value_same_period - current_final_value
  end

  def new_rate_final_value_new_period
    context.market_redemption * (((1 + context.new_asset_suggested_rate) * (1 + context.average_cdi)) ^ years_to_expire_with_new_rate)
  end

  def final_variation
    new_rate_final_value_new_period - current_final_value
  end

  def is_worth
    variation_same_period > 0 && final_variation > 0
  end
end