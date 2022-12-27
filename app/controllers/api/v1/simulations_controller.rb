class Api::V1::SimulationsController < ApplicationController
  before_action :authorize_request

  # GET /api/v1/simulations
  def index
    client = current_user.clients.find(simulation_params[:client_id])
    asset = client.assets.find(simulation_params[:asset_id])

    simulations = SimulationSerializer.new(asset.simulations).sanitized_hash

    render json: simulations
  end

  # GET /api/v1/simulations/:id
  def show
    client = current_user.clients.find(simulation_params[:client_id])
    asset = client.assets.find(simulation_params[:asset_id])
    simulation = asset.simulations.find(simulation_params[:id])

    simulation = SimulationSerializer.new(simulation).sanitized_hash

    render json: simulation
  end

  # POST /api/v1/simulations
  def create
    client = current_user.clients.find(simulation_params[:client_id])
    asset = client.assets.find(simulation_params[:asset_id])

    params = simulation_params.to_hash.transform_keys(&:to_sym)
    params[:asset] = asset

    interector = Simulation::BuildAttributes.call(params:)

    if interector.success?
      simulation = Simulation.create!(interector.result)

      simulation = SimulationSerializer.new(simulation).sanitized_hash
      render status: :created, json: simulation
    else
      render status: :bad_request, json: { error: interector.error }
    end
  end

  # PUT /api/v1/simulations/:id
  def update
    client = current_user.clients.find(simulation_params[:client_id])
    asset = client.assets.find(simulation_params[:asset_id])
    simulation = asset.simulations.find(simulation_params[:id])

    serializer_simulation = SimulationSerializer.new(simulation).sanitized_hash
    updated_params = serializer_simulation.merge(simulation_params)
    updated_params[:asset] = asset

    interector = Simulation::BuildAttributes.call(params: updated_params)

    if interector.success?
      simulation.update!(interector.result)

      simulation = SimulationSerializer.new(simulation).sanitized_hash
      render json: simulation
    else
      render status: :bad_request, json: { error: interector.error }
    end
  end

  # DELETE /api/v1/simulations/:id
  def destroy
    client = current_user.clients.find(simulation_params[:client_id])
    asset = client.assets.find(simulation_params[:asset_id])
    simulation = asset.simulations.find(simulation_params[:id])

    simulation.discard!

    simulation = SimulationSerializer.new(simulation).sanitized_hash
    render json: simulation
  end

  private

  def simulation_params
    params.permit(
      :id, :client_id, :asset_id, :new_asset_code, :new_asset_issuer, :new_asset_expiration_date,
      :new_asset_minimum_rate, :new_asset_maximum_rate, :new_asset_duration, :new_asset_indicative_rate,
      :new_asset_suggested_rate, :quotation_date, :average_cdi, :curve_volume, :market_redemption, :market_rate
    )
  end
end
