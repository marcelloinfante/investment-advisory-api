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

  describe "public methods" do
    let(:user) { create(:user) }
    let(:client) { create(:client, user:) }
    let(:assets) { create_list(:asset, 5, client:) }

    context "number_of_assets" do
      it "return the number of client assets" do
        number_of_assets = Client.first.number_of_assets
  
        expect(number_of_assets).to eq(5)
      end
    end

    context "total_amount_in_custody" do
      it "return the total amount in custody" do
        client = Client.first
        total_amount_in_custody = client.total_amount_in_custody

        total_volume_applied = client.assets.map { |asset| asset[:volume_applied] }.sum

        expect(total_amount_in_custody).to eq(total_volume_applied)
      end
    end
  end
end
