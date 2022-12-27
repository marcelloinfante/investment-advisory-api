class Api::V1::AssetsController < ApplicationController
  before_action :authorize_request

  # GET /api/v1/assets
  def index
    client = current_user.clients.find(asset_params[:client_id])
    assets = AssetSerializer.new(client.assets).sanitized_hash

    render json: assets
  end

  # GET /api/v1/assets/:id
  def show
    client = current_user.clients.find(asset_params[:client_id])
    asset = client.assets.find(asset_params[:id])
    asset = AssetSerializer.new(asset).sanitized_hash

    render json: asset
  end

  # POST /api/v1/assets
  def create
    current_user.clients.find(asset_params[:client_id])

    asset = Asset.new(asset_params)

    if asset.save
      asset = AssetSerializer.new(asset).sanitized_hash
      render status: :created, json: asset
    else
      render status: :bad_request, json: { error: asset.errors.messages }
    end
  end

  # PUT /api/v1/assets/:id
  def update
    client = current_user.clients.find(asset_params[:client_id])
    asset = client.assets.find(asset_params[:id])

    if asset.update(asset_params)
      asset = AssetSerializer.new(asset).sanitized_hash
      render json: asset
    else
      render status: :bad_request, json: { error: "Asset couldn't be updated." }
    end
  end

  # DELETE /api/v1/assets/:id
  def destroy
    client = current_user.clients.find(asset_params[:client_id])
    asset = client.assets.find(asset_params[:id])

    asset.discard!

    asset = AssetSerializer.new(asset).sanitized_hash
    render json: asset
  end

  private

  def asset_params
    params.permit(:id, :client_id, :code, :issuer, :rate_index, :entrance_rate,
    :quantity, :volume_applied, :application_date, :expiration_date)
  end
end
