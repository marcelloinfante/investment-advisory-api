require "rails_helper"

RSpec.describe "Api::V1::UsersController", type: :request do
  describe "POST signup" do
    it "assigns @teams" do

      post "/api/v1/user/signup", params: attributes_for(:user)
      p response
      p response.header
      p response.body
      expect(response).to have_http_status(200)
    end
  end
end