require "rails_helper"

RSpec.describe ApplicationController, type: :request do
  describe "methods" do
    let (:object) { ApplicationController.new }

    context "create_token" do
      it "return token" do
        token = object.create_token(1)

        expect(token).not_to be_empty
      end

      it "return token with user id" do
        token = object.create_token(1)
        decoded_token = JsonWebToken.decode(token)

        payload = {
          user_id: 1,
          exp: decoded_token[:exp]
        }

        expect(decoded_token).to eq(payload.transform_keys(&:to_s))
      end
    end

    # @TODO: Add other methods tests
  end
end