require 'rails_helper'

RSpec.describe Api::V1::ClientsController, type: :request do
  describe "GET index" do
    context "success scenario" do
      let(:user) { create(:user) }

      before(:each) do
        clients = create_list(:client, 5, user:)

        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        get "/api/v1/clients", headers:
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "return all clients from user" do
        returned_clients = JSON.parse(response.body)
        serialized_clients = ClientSerializer.new(user.clients).sanitized_hash

        expect(returned_clients).to eq(serialized_clients)
      end
    end

    context "error scenario" do
      context "user have no client" do
        before(:each) do
          user = create(:user)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/clients", headers:
        end

        it "return empty array" do
          returned_clients = JSON.parse(response.body)

          expect(returned_clients).to eq([])
        end
      end

      context "raise error if token is not provided" do
        before(:each) do
          get "/api/v1/clients"
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

          get "/api/v1/clients", headers: { "Authorization": "Bearer #{token}" }
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

          get "/api/v1/clients", headers: { "Authorization": "Bearer #{token}" }
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

          get "/api/v1/clients", headers: { "Authorization": "Bearer #{token}" }
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

      before(:each) do
        clients = create_list(:client, 5, user:)

        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        get "/api/v1/clients/#{clients.first.id}", headers:
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "return client from user" do
        returned_client = JSON.parse(response.body)
        serialized_client = ClientSerializer.new(user.clients.first).sanitized_hash

        expect(returned_client).to eq(serialized_client)
      end
    end

    context "error scenario" do
      context "client is not found" do
        before(:each) do
          user = create(:user)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          get "/api/v1/clients/1", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context "raise error if token is not provided" do
        before(:each) do
          get "/api/v1/clients/1"
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

          get "/api/v1/clients/1", headers: { "Authorization": "Bearer #{token}" }
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

          get "/api/v1/clients/1", headers: { "Authorization": "Bearer #{token}" }
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

          get "/api/v1/clients/1", headers: { "Authorization": "Bearer #{token}" }
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

      before(:each) do
        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }
        params = attributes_for(:client)

        post "/api/v1/clients", headers:, params:
      end

      it "have status 201" do
        expect(response).to have_http_status(:created)
      end

      it "create new client" do
        expect(Client.all).not_to be_empty
      end

      it "return new client" do
        returned_client = JSON.parse(response.body)
        serialized_client = ClientSerializer.new(user.clients.first).sanitized_hash

        expect(returned_client).to eq(serialized_client)
      end
    end

    context "error scenario" do
      context "first_name is not provided" do
        before(:each) do
          user = create(:user)
          params = attributes_for(:client)
          params.delete(:first_name)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/clients", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"first_name"=>["can't be blank"]}})
        end
      end

      context "last_name is not provided" do
        before(:each) do
          user = create(:user)
          params = attributes_for(:client)
          params.delete(:last_name)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/clients", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"last_name"=>["can't be blank"]}})
        end
      end

      context "email is not provided" do
        before(:each) do
          user = create(:user)
          params = attributes_for(:client)
          params.delete(:email)

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/clients", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"email"=>["can't be blank", "is invalid"]}})
        end
      end

      context "email is in wrong format" do
        before(:each) do
          user = create(:user)
          params = attributes_for(:client)
          params[:email] = "lkajsdfsdf"

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          post "/api/v1/clients", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>{"email"=>["is invalid"]}})
        end
      end

      context "raise error if token is not provided" do
        before(:each) do
          post "/api/v1/clients"
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

          post "/api/v1/clients", headers: { "Authorization": "Bearer #{token}" }
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

          post "/api/v1/clients", headers: { "Authorization": "Bearer #{token}" }
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

          post "/api/v1/clients", headers: { "Authorization": "Bearer #{token}" }
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
      let(:params) { attributes_for(:client) }
      let(:client) { create(:client, user:) }

      before(:each) do
        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        put "/api/v1/clients/#{client.id}", headers:, params:
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "update client" do
        client = Client.first
        serialized_client = ClientSerializer.new(client).sanitized_hash

        params[:id] = serialized_client[:id]

        serialized_client.delete(:number_of_assets)
        serialized_client.delete(:total_amount_in_custody)

        expect(serialized_client).to eq(params.transform_keys(&:to_s))
      end

      it "return updated client" do
        returned_client = JSON.parse(response.body)
        params[:id] = returned_client["id"]

        returned_client.delete("number_of_assets")
        returned_client.delete("total_amount_in_custody")

        expect(returned_client).to eq(params.transform_keys(&:to_s))
      end
    end

    context "error scenario" do
      context "email is in wrong format" do
        before(:each) do
          user = create(:user)
          client = create(:client, user:)

          params = attributes_for(:client)
          params[:email] = "akldsfjklsadf"

          user_id = user.id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          put "/api/v1/clients/#{client.id}", headers:, params:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          returned_client = JSON.parse(response.body)

          expect(returned_client).to eq({"error"=>"Client couldn't be updated."})
        end
      end

      context "raise error if token is not provided" do
        before(:each) do
          put "/api/v1/clients/1"
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

          put "/api/v1/clients/1", headers: { "Authorization": "Bearer #{token}" }
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

          put "/api/v1/clients/1", headers: { "Authorization": "Bearer #{token}" }
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

          put "/api/v1/clients/1", headers: { "Authorization": "Bearer #{token}" }
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

  describe "DELETE destroy" do
    context "success scenario" do
      let(:user) { create(:user) }
      let(:client) { create(:client, user:) }

      before(:each) do
        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        delete "/api/v1/clients/#{client.id}", headers:
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "delete client" do
        expect(Client.first).to be_discarded
      end

      it "return deleted client" do
        returned_client = JSON.parse(response.body)
        serialized_client = ClientSerializer.new(client).sanitized_hash

        expect(returned_client).to eq(serialized_client.transform_keys(&:to_s))
      end
    end

    context "error scenario" do
      context "client id not found" do
        before(:each) do
          user = create(:user)
          user_id = user.id

          token = JsonWebToken.encode({ user_id: })
  
          headers = { "Authorization": "Bearer #{token}" }
  
          delete "/api/v1/clients/1", headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "Couldn't find Client with 'id'=1 [WHERE \"clients\".\"user_id\" = $1]" }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if token is not provided" do
        before(:each) do
          delete "/api/v1/clients/1"
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

          delete "/api/v1/clients/1", headers: { "Authorization": "Bearer #{token}" }
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

          delete "/api/v1/clients/1", headers: { "Authorization": "Bearer #{token}" }
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

          delete "/api/v1/clients/1", headers: { "Authorization": "Bearer #{token}" }
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
