class Simulation::ValidateAttributes
  include Interactor

  def call
    context.error = {}

    params_reference.each do |value|
      unless context.params[value].class == String
        context.error[value] = "must have type String, not #{context.params[value].class}"
      end
    end

    context.error[:asset] = "Can't be blank" if context.params[:asset].blank?

    context.fail! if context.error.present?
  end

  private

  def params_reference
    [
      :average_cdi,
      :market_rate,
      :curve_volume,
      :quotation_date,
      :new_asset_code,
      :volume_applied,
      :new_asset_issuer,
      :market_redemption,
      :new_asset_duration,
      :new_asset_minimum_rate,
      :new_asset_maximum_rate,
      :new_asset_suggested_rate,
      :new_asset_indicative_rate,
      :new_asset_expiration_date
    ]
  end
end