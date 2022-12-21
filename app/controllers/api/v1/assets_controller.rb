class Api::V1::AssetsController < ApplicationController
  before_action :authorize_request

  # GET /api/v1/assets
  def index
    clients = AssetSerializer.new(current_user.clients).sanitized_hash

    render json: clients
  end

  # GET /api/v1/assets/:id
  def show
    client = current_user.clients.find(client_params[:id])
    client = AssetSerializer.new(client).sanitized_hash

    render json: client
  end

  # POST /api/v1/assets
  def create
    params = { user: current_user }.merge(client_params)
    client = Client.new(params)

    if client.save
      client = AssetSerializer.new(client).sanitized_hash
      render status: :created, json: client
    else
      render status: :bad_request, json: { error: client.errors.messages }
    end
  end

  # PUT /api/v1/assets/:id
  def update
    client = current_user.clients.find(client_params[:id])

    if client.update(client_params)
      client = AssetSerializer.new(client).sanitized_hash
      render json: client
    else
      render status: :bad_request, json: { error: "Asset couldn't be updated." }
    end
  end

  # DELETE /api/v1/assets/:id
  def destroy
    client = current_user.clients.find(client_params[:id])

    if client.discard
      client = AssetSerializer.new(client).sanitized_hash
      render json: client
    else
      render status: :bad_request, json: { error: "Asset couldn't be deleted." }
    end
  end

  private

  def asset_params
    params.permit(:id, :code, :issuer, :rate_index,
    :entrance_rate, :quantity, :application_date, :expiration_date)
  end
end
