require "rails_helper"

RSpec.describe JsonWebToken do
  describe "methods" do
    it "return encoded token" do
      token = JsonWebToken.encode({ user_id: 1 })

      expect(token).not_to be_empty
    end

    it "return decoded hash" do
      payload = { user_id: 1 }
      token = JsonWebToken.encode(payload)

      decoded_hash = JsonWebToken.decode(token)

      payload[:exp] = decoded_hash[:exp]
      expect(decoded_hash).to eq(payload.transform_keys(&:to_s))
    end
  end
end