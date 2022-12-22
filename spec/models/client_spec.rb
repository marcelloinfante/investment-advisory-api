require 'rails_helper'

RSpec.describe Client, type: :model do
  describe "association" do
    it { should have_many(:assets) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    context "presence" do
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:email) }
    end

    context "uniqueness" do
      it { should validate_uniqueness_of(:email) }
    end
  end

  describe "callbacks" do
    context "discard" do
      it "discard all assets associated with the client" do
        user = create(:user)
        client = create(:client, user:)
        assets = create_list(:asset, 5, client:)

        client.discard
        not_deleted_assets = client.assets.kept

        expect(not_deleted_assets).to be_empty
      end

      it "undiscard all assets associated with the client" do
        user = create(:user)
        client = create(:client, user:)
        assets = create_list(:asset, 5, client:)

        client.discard
        client.undiscard
        deleted_assets = client.assets.discarded

        expect(deleted_assets).to be_empty
      end
    end
  end
end
