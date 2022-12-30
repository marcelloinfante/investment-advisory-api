require "rails_helper"

RSpec.describe AssetSerializer do
  context "serialized hash" do
    it "return serialized asset" do
      user = create(:user)
      client = create(:client, user:)
      asset = create(:asset, client:)

      serialized_asset = AssetSerializer.new(asset).sanitized_hash

      expect(serialized_asset).to include({
        id: asset.id,
        code: asset.code,
        issuer: asset.issuer,
        quantity: asset.quantity,
        rate_index: asset.rate_index,
        entrance_rate: asset.entrance_rate,
        volume_applied: asset.volume_applied,
        expiration_date: asset.expiration_date,
        application_date: asset.application_date
      })
    end
  end
end