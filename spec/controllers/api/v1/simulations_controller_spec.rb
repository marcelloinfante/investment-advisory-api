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
    end

    context "error scenario" do
      context "client_id is not found" do
        before(:each) do
          user = create(:user)
          params = attributes_for(:asset)
          params[:client_id] = 1

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/assets", headers:, params:
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
          params = attributes_for(:asset)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/assets", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>"Couldn't find Client without an ID"})
        end
      end

      context "code is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          params = attributes_for(:asset)
          params[:client_id] = client.id

          params.delete(:code)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/assets", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"code"=>["can't be blank"]}})
        end
      end

      context "issuer is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          params = attributes_for(:asset)
          params[:client_id] = client.id

          params.delete(:issuer)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/assets", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"issuer"=>["can't be blank"]}})
        end
      end

      context "rate_index is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          params = attributes_for(:asset)
          params[:client_id] = client.id

          params.delete(:rate_index)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/assets", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"rate_index"=>["can't be blank"]}})
        end
      end

      context "entrance_rate is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          params = attributes_for(:asset)
          params[:client_id] = client.id

          params.delete(:entrance_rate)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/assets", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"entrance_rate"=>["can't be blank"]}})
        end
      end

      context "quantity is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          params = attributes_for(:asset)
          params[:client_id] = client.id

          params.delete(:quantity)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/assets", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"quantity"=>["can't be blank"]}})
        end
      end

      context "application_date is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          params = attributes_for(:asset)
          params[:client_id] = client.id

          params.delete(:application_date)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/assets", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"application_date"=>["can't be blank"]}})
        end
      end

      context "expiration_date is not provided" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)
          params = attributes_for(:asset)
          params[:client_id] = client.id

          params.delete(:expiration_date)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/assets", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"expiration_date"=>["can't be blank"]}})
        end
      end

      context "raise error if token is not provided" do
        before(:each) do
          post "/api/v1/assets"
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

          post "/api/v1/assets", headers: { "Authorization": "Bearer #{token}" }
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

          post "/api/v1/assets", headers: { "Authorization": "Bearer #{token}" }
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

          post "/api/v1/assets", headers: { "Authorization": "Bearer #{token}" }
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
