require "rails_helper"

RSpec.describe AssetSerializer do
  context "serialized hash" do
    it "return serialized asset" do
      user = create(:user)
      client = create(:client, user:)
      assset = create(:asset, client:)

      serialized_asset = AssetSerializer.new(assset).sanitized_hash

      expect(serialized_asset).to include({
        id: assset.id,
        code: assset.code,
        issuer: assset.issuer,
        rate_index: assset.rate_index,
        entrance_rate: assset.entrance_rate,
        quantity: assset.quantity,
        application_date: assset.application_date.to_i,
        expiration_date: assset.expiration_date.to_i
      })
    end
  end
end