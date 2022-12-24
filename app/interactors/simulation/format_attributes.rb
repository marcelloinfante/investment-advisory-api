class Simulation::FormatAttributes
  include Interactor

  def call
    context.formatted_params = {
      asset: context.params[:asset],
      average_cdi: context.params[:average_cdi].to_f,
      market_rate: context.params[:market_rate].to_f,
      curve_volume: context.params[:curve_volume].to_i,
      new_asset_code: context.params[:new_asset_code],
      new_asset_issuer: context.params[:new_asset_issuer],
      entrance_rate: context.params[:asset].entrance_rate,
      volume_applied: context.params[:volume_applied].to_i,
      market_redemption: context.params[:market_redemption].to_i,
      quotation_date: Date.parse(context.params[:quotation_date]),
      new_asset_duration: context.params[:new_asset_duration].to_i,
      new_asset_minimum_rate: context.params[:new_asset_minimum_rate].to_f,
      new_asset_maximum_rate: context.params[:new_asset_maximum_rate].to_f,
      new_asset_suggested_rate: context.params[:new_asset_suggested_rate].to_f,
      new_asset_indicative_rate: context.params[:new_asset_indicative_rate].to_f,
      new_asset_expiration_date: Date.parse(context.params[:new_asset_expiration_date]),
      current_asset_expiration_date: context.params[:asset].expiration_date.to_datetime
    }
  end
end