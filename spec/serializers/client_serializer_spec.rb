require "rails_helper"

RSpec.describe ClientSerializer do
  context "serialized hash" do
    it "return serialized client" do
      user = create(:user)
      client = create(:client, user:)
      serialized_client = ClientSerializer.new(client).sanitized_hash

      expect(serialized_client).to include({
        id: client.id,
        first_name: client.first_name,
        last_name: client.last_name,
        email: client.email
      })
    end
  end
end