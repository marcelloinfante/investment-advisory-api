require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :request do
  describe "GET refresh" do
    context "success scenario" do
      let(:user) { create(:user) }

      before(:each) do
        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        get "/api/v1/user/refresh", headers:
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "return json web token" do
        body = JSON.parse(response.body).with_indifferent_access
        token = body[:token]
  
        expect(token).not_to be_empty
      end
    end

    context "error scenario" do
      context "raise error if token is not provided" do
        before(:each) do
          get "/api/v1/user"
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

          get "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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

          get "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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

          get "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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

  describe "POST signup" do
    context "success scenario" do
      let(:user_params) { attributes_for(:user).with_indifferent_access }

      before(:each) do
        post "/api/v1/user/signup", params: user_params
      end

      it "have status 201" do
        expect(response).to have_http_status(:created)
      end
  
      it "create new user" do
        expect(User.all).not_to be_empty
      end
  
      it "return json web token" do
        body = JSON.parse(response.body).with_indifferent_access
        token = body[:token]
  
        expect(token).not_to be_empty
      end
    end

    context "error scenario" do
      context "raise error if first_name is not provided" do
        before(:each) do
          post "/api/v1/user/signup", params: attributes_for(:user, first_name: nil)
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => { "first_name" => ["can't be blank"] }}

          expect(body).to eq(error_message)
        end
      end

      context "raise error if last_name is not provided" do
        before(:each) do
          post "/api/v1/user/signup", params: attributes_for(:user, last_name: nil)
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => { "last_name" => ["can't be blank"] }}

          expect(body).to eq(error_message)
        end
      end

      context "raise error if email is not provided" do
        before(:each) do
          post "/api/v1/user/signup", params: attributes_for(:user, email: nil)
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => { "email" => ["can't be blank", "is invalid"] }}

          expect(body).to eq(error_message)
        end
      end

      context "raise error if password is not provided" do
        before(:each) do
          post "/api/v1/user/signup", params: attributes_for(:user, password: nil)
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => { "password" => ["can't be blank"] }}

          expect(body).to eq(error_message)
        end
      end

      context "raise error if password confirmation don't macht" do
        before(:each) do
          post "/api/v1/user/signup", params: attributes_for(:user, password_confirmation: "asdfsajdhf")
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => { "password_confirmation" => ["doesn't match Password"] }}

          expect(body).to eq(error_message)
        end
      end

      context "raise error if email already exists" do
        before(:each) do
          user_params = attributes_for(:user).with_indifferent_access
          User.create(user_params)

          new_user_params = attributes_for(:user, email: user_params[:email])
          post "/api/v1/user/signup", params: new_user_params
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => { "email" => ["has already been taken"] }}

          expect(body).to eq(error_message)
        end
      end

      context "raise error if email is in wrong format" do
        before(:each) do
          user_params = attributes_for(:user, email: "abcdefghjkjsj")

          post "/api/v1/user/signup", params: user_params
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => { "email" => ["is invalid"] }}

          expect(body).to eq(error_message)
        end
      end
    end
  end

  describe "POST signin" do
    context "success scenario" do
      let(:user_params) { attributes_for(:user).with_indifferent_access }

      before(:each) do
        User.create(user_params)
        post "/api/v1/user/signin", params: user_params
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "return json web token" do
        body = JSON.parse(response.body).with_indifferent_access
        token = body[:token]

        expect(token).not_to be_empty
      end
    end

    context "error scenario" do
      context "raise error if password is not provided" do
        before(:each) do
          user_params = attributes_for(:user).with_indifferent_access
          User.create(user_params)

          user_params[:password] = nil
          post "/api/v1/user/signin", params: user_params
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "Incorrect username or password." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if password is wrong" do
        before(:each) do
          user_params = attributes_for(:user).with_indifferent_access
          User.create(user_params)

          user_params[:password] = "abcdefg"
          post "/api/v1/user/signin", params: user_params
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "Incorrect username or password." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if user is not found" do
        before(:each) do
          user_params = attributes_for(:user).with_indifferent_access
          User.create(user_params)

          user_params[:email] = "exemple@exemple.com"
          post "/api/v1/user/signin", params: user_params
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "Incorrect username or password." }

          expect(body).to eq(error_message)
        end
      end

      context "raise error if email is not provided" do
        before(:each) do
          user_params = attributes_for(:user).with_indifferent_access
          User.create(user_params)

          user_params[:email] = nil
          post "/api/v1/user/signin", params: user_params
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "Incorrect username or password." }

          expect(body).to eq(error_message)
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "success scenario" do
      let(:user_params) { attributes_for(:user).with_indifferent_access }

      before(:each) do
        user_id = User.create(user_params).id
        token = JsonWebToken.encode({ user_id: })

        delete "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "return serialized user" do
        body = JSON.parse(response.body).with_indifferent_access
        returned_user = body.transform_keys(&:to_sym)

        user_params.delete(:password)
        user_params.delete(:password_confirmation)

        expect(returned_user).to eq(user_params)
      end

      it "soft-delete user" do
        user = User.find_by_email(user_params[:email])

        expect(user).to be_discarded
      end
    end

    context "error scenario" do
      context "raise error if token is not provided" do
        before(:each) do
          delete "/api/v1/user"
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

          delete "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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

      context "raise error if user is already deleted" do
        before(:each) do
          user = create(:user)
          user.discard
          token = JsonWebToken.encode({ user_id: user.id })

          delete "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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

          delete "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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
      let(:user_params) { attributes_for(:user).with_indifferent_access }
      let(:params) { attributes_for(:user).with_indifferent_access }

      before(:each) do
        user_id = User.create(user_params).id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        put "/api/v1/user", params:, headers:
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "return serialized user" do
        body = JSON.parse(response.body).with_indifferent_access
        returned_user = body.transform_keys(&:to_sym)

        params.delete(:password)
        params.delete(:password_confirmation)

        expect(returned_user).to eq(params)
      end
    end

    context "error scenario" do
      context "raise error if token is not provided" do
        before(:each) do
          put "/api/v1/user"
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

          put "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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

          put "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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

          put "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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

      context "raise error if email already exists" do
        before(:each) do
          user_id = create(:user).id
          token = JsonWebToken.encode({ user_id: })

          headers = { "Authorization": "Bearer #{token}" }

          new_user = create(:user)
          params = attributes_for(:user, email: new_user.email)

          put "/api/v1/user", params:, headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User couldn't be updated."}

          expect(body).to eq(error_message)
        end
      end

      context "raise error if email is in wrong format" do
        before(:each) do
          user_id = create(:user).id
          token = JsonWebToken.encode({ user_id: })

          params = attributes_for(:user, email: "abcdefghjkjsj")
          headers = { "Authorization": "Bearer #{token}" }

          put "/api/v1/user", params:, headers:
        end

        it "return status 400" do
          expect(response).to have_http_status(:bad_request)
        end

        it "return error message" do
          body = JSON.parse(response.body)
          error_message = { "error" => "User couldn't be updated."}

          expect(body).to eq(error_message)
        end
      end
    end
  end

  describe "GET show" do
    context "success scenario" do
      let(:user) { create(:user) }

      before(:each) do
        user_id = user.id
        token = JsonWebToken.encode({ user_id: })

        headers = { "Authorization": "Bearer #{token}" }

        get "/api/v1/user", headers:
      end

      it "have status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "return serialized user" do
        body = JSON.parse(response.body).with_indifferent_access
        returned_user = body.transform_keys(&:to_sym)

        serialized_user = UserSerializer.new(user).sanitized_hash

        expect(returned_user).to eq(serialized_user)
      end
    end

    context "error scenario" do
      context "raise error if token is not provided" do
        before(:each) do
          get "/api/v1/user"
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

          get "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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

          get "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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

          get "/api/v1/user", headers: { "Authorization": "Bearer #{token}" }
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