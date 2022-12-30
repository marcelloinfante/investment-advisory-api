require "rails_helper"

RSpec.describe ClientSerializer do
  context "serialized hash" do
    it "return serialized client" do
      user = create(:user)
      client = create(:client, user:)
      serialized_client = ClientSerializer.new(client).sanitized_hash

      expect(serialized_client).to include({
        id: client.id,
        email: client.email,
        last_name: client.last_name,
        first_name: client.first_name,
        number_of_assets: client.number_of_assets,
        total_in_custody: client.total_in_custody
      })
    end
  end
end