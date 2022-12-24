require 'rails_helper'

RSpec.describe Api::V1::SimulationsController, type: :request do
  describe "GET index" do
    context "success scenario" do
      let(:user) { create(:user) }
      let(:client) { create(:client, user:) }
      let(:asset) { create(:asset, client:) }
      let(:simulations) { create_list(:simulation, 5, asset:) }

      before(:each) do
        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        get "/api/v1/simulations?client_id=#{client.id}&asset_id=#{asset.id}", headers:
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "return all simulations from asset" do
        returned_simulations = JSON.parse(response.body)
        serialized_simulations = SimulationSerializer.new(asset.simulations).sanitized_hash

        expect(returned_simulations).to eq(serialized_simulations)
      end
    end

    context "error scenario" do
      context "asset have no simulation" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations?client_id=#{client.id}&asset_id=#{asset.id}", headers:
        end

        it "return empty array" do
          returned_simulations = JSON.parse(response.body)

          expect(returned_simulations).to eq([])
        end
      end

      context "client is not provided" do
        let(:user) { create(:user) }

        before(:each) do
          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]
          expect(error_message).to include("Couldn't find Client with")
        end
      end

      context "asset is not provided" do
        let(:user) { create(:user) }
        let(:client) { create(:client, user:) }

        before(:each) do
          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations?client_id=#{client.id}", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]
          expect(error_message).to include("Couldn't find Asset with")
        end
      end

      context "raise error if asset don't belongs to client" do
        let(:user) { create(:user) }
        let(:client) { create(:client, user:) }
        let(:other_client) { create(:client, user:) }
        let(:asset) { create(:asset, client:) }

        before(:each) do
          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations?client_id=#{other_client.id}&asset_id=#{asset.id}", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]
          expect(error_message).to include("Couldn't find Asset with")
        end
      end

      context "raise error if client don't belongs to current user" do
        let(:current_user) { create(:user) }
        let(:other_user) { create(:user) }
        let(:client) { create(:client, user: current_user) }

        before(:each) do
          user_id = other_user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations?client_id=#{client.id}", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]
          expect(error_message).to include("Couldn't find Client with")
        end
      end

      context "raise error if token is not provided" do
        before(:each) do
          get "/api/v1/simulations", headers:
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if token is invalid" do
        before(:each) do
          token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyNzl9.T-B9ZoVNSUyt7PQk50ldKUm1wI5mP2OSP6urI-8XgV4"

          get "/api/v1/simulations", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if token is expired" do
        before(:each) do
          user = create(:user)
          token = JsonWebToken.encode({ user_id: user.id }, Time.now - 1.hour)

          get "/api/v1/simulations", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if user is deleted" do
        before(:each) do
          user = create(:user)
          user.discard
          token = JsonWebToken.encode({ user_id: user.id })

          get "/api/v1/simulations", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end
    end
  end

  describe "GET show" do
    context "success scenario" do
      let(:user) { create(:user) }
      let(:client) { create(:client, user:) }
      let(:asset) { create(:asset, client:) }
      let(:simulation) { create(:simulation, asset:) }

      before(:each) do
        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        get "/api/v1/simulations/#{simulation.id}?client_id=#{client.id}&asset_id=#{asset.id}", headers:
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "return simulation from asset" do
        returned_simulation = response.body
        serialized_simulation = SimulationSerializer.new(asset.simulations.first).sanitized_hash

        expect(returned_simulation).to eq(serialized_simulation.to_json)
      end
    end

    context "error scenario" do
      context "simulation is not found" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations/1?client_id=#{client.id}&asset_id=#{asset.id}", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]

          expect(error_message).to include("Couldn't find Simulation with")
        end
      end

      context "client is not found" do
        before(:each) do
          user = create(:user)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations/1?client_id=1", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]

          expect(error_message).to include("Couldn't find Client with")
        end
      end

      context "client is not provided" do
        before(:each) do
          user = create(:user)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations/1", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]

          expect(error_message).to include("Couldn't find Client with")
        end
      end

      context "asset is not found" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations/1?client_id=#{client.id}&asset_id=1", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]

          expect(error_message).to include("Couldn't find Asset with")
        end
      end

      context "asset is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations/1?client_id=#{client.id}", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]

          expect(error_message).to include("Couldn't find Asset with")
        end
      end

      context "raise error if client don't belongs to current user" do
        let(:other_user) { create(:user) }
        let(:current_user) { create(:user) }
        let(:client) { create(:client, user: current_user) }

        before(:each) do
          user_id = other_user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations/1?client_id=#{client.id}", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]
          expect(error_message).to include("Couldn't find Client with")
        end
      end

      context "raise error if asset don't belongs to client" do
        let(:user) { create(:user) }
        let(:client) { create(:client, user:) }
        let(:other_client) { create(:client, user:) }
        let(:asset) { create(:asset, client:) }
        let(:simulation) { create(:simulation, asset:) }

        before(:each) do
          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations/#{simulation.id}?client_id=#{other_client.id}&asset_id=#{asset.id}", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]
          expect(error_message).to include("Couldn't find Asset with")
        end
      end

      context "raise error if simulation don't belongs to asset" do
        let(:user) { create(:user) }
        let(:client) { create(:client, user:) }
        let(:other_asset) { create(:asset, client:) }
        let(:asset) { create(:asset, client:) }
        let(:simulation) { create(:simulation, asset:) }

        before(:each) do
          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/simulations/#{simulation.id}?client_id=#{client.id}&asset_id=#{other_asset.id}", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]
          expect(error_message).to include("Couldn't find Simulation with")
        end
      end

      context "raise error if token is not provided" do
        before(:each) do
          get "/api/v1/simulations/1"
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if token is invalid" do
        before(:each) do
          token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyNzl9.T-B9ZoVNSUyt7PQk50ldKUm1wI5mP2OSP6urI-8XgV4"

          get "/api/v1/simulations/1", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if token is expired" do
        before(:each) do
          user = create(:user)
          token = JsonWebToken.encode({ user_id: user.id }, Time.now - 1.hour)

          get "/api/v1/simulations/1", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if user is deleted" do
        before(:each) do
          user = create(:user)
          user.discard
          token = JsonWebToken.encode({ user_id: user.id })

          get "/api/v1/simulations/1", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end
    end
  end

  describe "POST create" do
    context "success scenario" do
      let(:user) { create(:user) }
      let(:client) { create(:client, user:) }
      let(:asset) { create(:asset, client:) }

      before(:each) do
        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        params = attributes_for(:simulation)
        params[:client_id] = client.id
        params[:asset_id] = asset.id

        post "/api/v1/simulations", headers:, params:
      end

      it "have status 201" do
        expect(response).to have_http_status(:created)
      end

      it "create new simulation" do
        expect(Simulation.all).not_to be_empty
      end

      it "return new simulation" do
        returned_simulation = response.body
        serialized_simulation = SimulationSerializer.new(asset.simulations.first).sanitized_hash

        expect(returned_simulation).to eq(serialized_simulation.to_json)
      end

      it "have association with asset" do
        simulation_asset = Simulation.first.asset

        expect(simulation_asset).to be_present
      end
    end

    context "error scenario" do
      context "client_id is not found" do
        before(:each) do
          user = create(:user)
          params = attributes_for(:simulation)
          params[:client_id] = 1

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]

          expect(error_message).to include("Couldn't find Client with")
        end
      end

      context "client_id is not provided" do
        before(:each) do
          user = create(:user)
          params = attributes_for(:simulation)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>"Couldn't find Client without an ID"})
        end
      end

      context "asset_id is not found" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          params = attributes_for(:simulation, client_id: client.id)
          params[:asset_id] = 1

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]

          expect(error_message).to include("Couldn't find Asset with")
        end
      end

      context "asset_id is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          params = attributes_for(:simulation, client_id: client.id)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>"Couldn't find Asset without an ID"})
        end
      end

      context "average_cdi is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:average_cdi)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"average_cdi"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "market_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:market_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"market_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "curve_volume is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:curve_volume)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"curve_volume"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "quotation_date is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:quotation_date)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"quotation_date"=>"must have type String or DateTime or ActiveSupport::TimeWithZone, not NilClass"}})
        end
      end

      context "new_asset_code is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_code)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_code"=>"must have type String, not NilClass"}})
        end
      end

      context "volume_applied is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:volume_applied)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"volume_applied"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "new_asset_issuer is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_issuer)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_issuer"=>"must have type String, not NilClass"}})
        end
      end

      context "market_redemption is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:market_redemption)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"market_redemption"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "new_asset_duration is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_duration)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_duration"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "new_asset_minimum_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_minimum_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_minimum_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_maximum_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_maximum_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_maximum_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_suggested_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_suggested_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_suggested_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_indicative_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_indicative_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_indicative_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_expiration_date is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_expiration_date)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_expiration_date"=>"must have type String or DateTime or ActiveSupport::TimeWithZone, not NilClass"}})
        end
      end

      context "average_cdi is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:average_cdi)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"average_cdi"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "market_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:market_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"market_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "curve_volume is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:curve_volume)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"curve_volume"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "quotation_date is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:quotation_date)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"quotation_date"=>"must have type String or DateTime or ActiveSupport::TimeWithZone, not NilClass"}})
        end
      end

      context "new_asset_code is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_code)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_code"=>"must have type String, not NilClass"}})
        end
      end

      context "volume_applied is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:volume_applied)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"volume_applied"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "new_asset_issuer is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_issuer)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_issuer"=>"must have type String, not NilClass"}})
        end
      end

      context "market_redemption is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:market_redemption)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"market_redemption"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "new_asset_duration is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_duration)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_duration"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "new_asset_minimum_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_minimum_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_minimum_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_maximum_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_maximum_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_maximum_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_suggested_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_suggested_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_suggested_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_indicative_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_indicative_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_indicative_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_expiration_date is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params.delete(:new_asset_expiration_date)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_expiration_date"=>"must have type String or DateTime or ActiveSupport::TimeWithZone, not NilClass"}})
        end
      end

      context "average_cdi is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:average_cdi] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"average_cdi"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "market_rate is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:market_rate] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"market_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "curve_volume is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:curve_volume] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"curve_volume"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "quotation_date is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:quotation_date] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"quotation_date"=>"must have type String or DateTime or ActiveSupport::TimeWithZone, not NilClass"}})
        end
      end

      context "new_asset_code is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:new_asset_code] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_code"=>"must have type String, not NilClass"}})
        end
      end

      context "volume_applied is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:volume_applied] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"volume_applied"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "new_asset_issuer is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:new_asset_issuer] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_issuer"=>"must have type String, not NilClass"}})
        end
      end

      context "market_redemption is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:market_redemption] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"market_redemption"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "new_asset_duration is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:new_asset_duration] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_duration"=>"must have type String or Integer, not NilClass"}})
        end
      end

      context "new_asset_minimum_rate is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:new_asset_minimum_rate] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_minimum_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_maximum_rate is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:new_asset_maximum_rate] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_maximum_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_suggested_rate is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:new_asset_suggested_rate] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_suggested_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_indicative_rate is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:new_asset_indicative_rate] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_indicative_rate"=>"must have type String or Float, not NilClass"}})
        end
      end

      context "new_asset_expiration_date is nil" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:simulation)
          params[:client_id] = client.id
          params[:asset_id] = asset.id

          params[:new_asset_expiration_date] = nil

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/simulations", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"new_asset_expiration_date"=>"must have type String or DateTime or ActiveSupport::TimeWithZone, not NilClass"}})
        end
      end

      context "raise error if token is not provided" do
        before(:each) do
          post "/api/v1/simulations"
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if token is invalid" do
        before(:each) do
          token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyNzl9.T-B9ZoVNSUyt7PQk50ldKUm1wI5mP2OSP6urI-8XgV4"

          post "/api/v1/simulations", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if token is expired" do
        before(:each) do
          user = create(:user)
          token = JsonWebToken.encode({ user_id: user.id }, Time.now - 1.hour)

          post "/api/v1/simulations", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if user is deleted" do
        before(:each) do
          user = create(:user)
          user.discard
          token = JsonWebToken.encode({ user_id: user.id })

          post "/api/v1/simulations", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end
    end
  end

  describe "PUT update" do
    context "success scenario" do
      let(:user) { create(:user) }
      let(:client) { create(:client, user:) }
      let(:asset) { create(:asset, client:) }
      let(:simulation) { create(:simulation, asset:) }

      let(:params) { attributes_for(:simulation, client_id: client.id, asset_id: asset.id ) }

      before(:each) do
        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        put "/api/v1/simulations/#{simulation.id}", headers:, params:
      end

      # it "have status 200" do
      #   expect(response).to have_http_status(:ok)
      # end

      it "update simulation" do
        simulation = Simulation.first
        serialized_simulation = SimulationSerializer.new(simulation).sanitized_hash

        expect(serialized_simulation).to eq(params.transform_keys(&:to_s))
      end

    #   it "return updated asset" do
    #     returned_asset = JSON.parse(response.body).transform_keys(&:to_sym)

    #     params[:id] = returned_asset[:id]
    #     params[:application_date] = params[:application_date].to_i
    #     params[:expiration_date] = params[:expiration_date].to_i
    #     params[:entrance_rate] = params[:entrance_rate].to_s

    #     returned_asset[:client_id] = client.id

    #     expect(returned_asset).to eq(params)
    #   end
    end

    context "error scenario" do
      context "client_id is not found" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          asset = create(:asset, client:)
          params = attributes_for(:asset, client_id: 100000)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          put "/api/v1/assets/#{asset.id}", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = body["error"]

          expect(error_message).to include("Couldn't find Client with")
        end
      end

      context "client_id is not provided" do
        before(:each) do
          user = create(:user)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          put "/api/v1/assets/1", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>"Couldn't find Client without an ID"})
        end
      end

      context "raise error if token is not provided" do
        before(:each) do
          put "/api/v1/assets/1"
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if token is invalid" do
        before(:each) do
          token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyNzl9.T-B9ZoVNSUyt7PQk50ldKUm1wI5mP2OSP6urI-8XgV4"

          put "/api/v1/assets/1", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if token is expired" do
        before(:each) do
          user = create(:user)
          token = JsonWebToken.encode({ user_id: user.id }, Time.now - 1.hour)

          put "/api/v1/assets/1", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if user is deleted" do
        before(:each) do
          user = create(:user)
          user.discard
          token = JsonWebToken.encode({ user_id: user.id })

          put "/api/v1/assets/1", headers: { "Authorization": "Bearer #{token}" }
        end

        it "return status 401" do
          expect(response).to have_http_status(:unauthorized)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User is not logged in/could not be found." }

          expect(body).to eq(error_message)
        end
      end
    end
  end
end
