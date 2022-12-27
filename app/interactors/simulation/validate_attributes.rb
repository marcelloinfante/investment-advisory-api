class Simulation::ValidateAttributes
  include Interactor

  def call
    context.error = {}

    params_reference.each do |param, allowed_types|
      param_type = context.params[param].class

      unless allowed_types.include?(param_type)
        context.error[param] = "must have type #{allowed_types.join(" or ")}, not #{param_type}"
      end
    end

    context.fail! if context.error.present?
  end

  private

  def params_reference
    {
      asset: [Asset],
      average_cdi: [String, Float],
      market_rate: [String, Float],
      curve_volume: [String, Float],
      quotation_date: [String, DateTime, ActiveSupport::TimeWithZone],
      new_asset_code: [String],
      new_asset_issuer: [String],
      market_redemption: [String, Float],
      new_asset_duration: [String, Float],
      new_asset_minimum_rate: [String, Float],
      new_asset_maximum_rate: [String, Float],
      new_asset_suggested_rate: [String, Float],
      new_asset_indicative_rate: [String, Float],
      new_asset_expiration_date: [String, DateTime, ActiveSupport::TimeWithZone]
    }
  end
end