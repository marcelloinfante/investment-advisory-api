class Api::V1::ClientsController < ApplicationController
  before_action :authorize_request

  # GET /api/v1/clients
  def index
    clients = ClientSerializer.new(current_user.clients).sanitized_hash

    render json: clients
  end

  # GET /api/v1/clients/:id
  def show
    client = current_user.clients.find(client_params[:id])
    client = ClientSerializer.new(client).sanitized_hash

    render json: client
  end

  # POST /api/v1/clients
  def create
    params = { user: current_user }.merge(client_params)
    client = Client.new(params)

    if client.save
      client = ClientSerializer.new(client).sanitized_hash
      render status: :created, json: client
    else
      render status: :bad_request, json: { error: client.errors.messages }
    end
  end

  # PUT /api/v1/clients/:id
  def update
    client = current_user.clients.find(client_params[:id])

    if client.update(client_params)
      client = ClientSerializer.new(client).sanitized_hash
      render json: client
    else
      render status: :bad_request, json: { error: "Client couldn't be updated." }
    end
  end

  # DELETE /api/v1/clients/:id
  def destroy
    client = current_user.clients.find(client_params[:id])

    client.discard!

    client = ClientSerializer.new(client).sanitized_hash
    render json: client
  end

  private

  def client_params
    params.permit(:id, :first_name, :last_name, :email)
  end
end
