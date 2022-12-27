class Simulation::FormatAttributes
  include Interactor

  def call
    context.formatted_params = {
      asset:,
      average_cdi:,
      market_rate:,
      curve_volume:,
      entrance_rate:,
      new_asset_code:,
      quotation_date:,
      volume_applied:,
      new_asset_issuer:,
      market_redemption:,
      new_asset_duration:,
      new_asset_minimum_rate:,
      new_asset_maximum_rate:,
      new_asset_suggested_rate:,
      new_asset_indicative_rate:,
      new_asset_expiration_date:,
      current_asset_expiration_date:
    }
  end

  private

  def asset
    context.params[:asset]
  end

  def average_cdi
    context.params[:average_cdi].to_f
  end

  def market_rate
    context.params[:market_rate].to_f
  end

  def curve_volume
    context.params[:curve_volume].to_f
  end

  def entrance_rate
    context.params[:asset].entrance_rate
  end

  def new_asset_code
    context.params[:new_asset_code]
  end

  def quotation_date
    Date.parse(context.params[:quotation_date])
  end

  def volume_applied
    context.params[:asset].volume_applied.to_f
  end

  def new_asset_issuer
    context.params[:new_asset_issuer]
  end

  def market_redemption
    context.params[:market_redemption].to_f
  end

  def new_asset_duration
    context.params[:new_asset_duration].to_f
  end

  def new_asset_minimum_rate
    context.params[:new_asset_minimum_rate].to_f
  end

  def new_asset_maximum_rate
    context.params[:new_asset_maximum_rate].to_f
  end

  def new_asset_suggested_rate
    context.params[:new_asset_suggested_rate].to_f
  end

  def new_asset_indicative_rate
    context.params[:new_asset_indicative_rate].to_f
  end

  def new_asset_expiration_date
    Date.parse(context.params[:new_asset_expiration_date])
  end

  def current_asset_expiration_date
    context.params[:asset].expiration_date.to_datetime
  end
end