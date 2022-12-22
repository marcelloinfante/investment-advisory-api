require 'rails_helper'

RSpec.describe Asset, type: :model do
  describe "association" do
    it { should have_many(:simulations) }
    it { should belong_to(:client) }
  end

  describe "validations" do
    context "presence" do
      it { should validate_presence_of(:code) }
      it { should validate_presence_of(:issuer) }
      it { should validate_presence_of(:rate_index) }
      it { should validate_presence_of(:entrance_rate) }
      it { should validate_presence_of(:quantity) }
      it { should validate_presence_of(:application_date) }
      it { should validate_presence_of(:expiration_date) }
    end
  end

  describe "callbacks" do
    context "discard" do
      it "discard all simulations associated with the asset" do
        user = create(:user)
        client = create(:client, user:)
        asset = create(:asset, client:)
        simulation = create(:simulation, asset:)

        asset.discard
        not_deleted_simulations = asset.simulations.kept

        expect(not_deleted_simulations).to be_empty
      end

      it "undiscard all simulations associated with the asset" do
        user = create(:user)
        client = create(:client, user:)
        asset = create(:asset, client:)
        simulation = create(:simulation, asset:)

        asset.discard
        asset.undiscard
        deleted_simulations = asset.simulations.discarded

        expect(deleted_simulations).to be_empty
      end
    end
  end
end
