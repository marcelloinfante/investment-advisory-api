require "rails_helper"

RSpec.describe User, type: :model do
  describe "association" do
    it { should have_many(:clients) }
    it { should belong_to(:company).optional }
  end

  describe "validations" do
    context "has_secure_password" do
      it { should have_secure_password }
      it { should have_secure_password(:recovery_password) }
    end

    context "presence" do
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:password) }
    end

    context "uniqueness" do
      it { should validate_uniqueness_of(:email) }
    end
  end

  describe "callbacks" do
    context "discard" do
      it "discard all clients associated with the user" do
        user = create(:user)
        clients = create_list(:client, 5, user:)

        user.discard
        not_deleted_clients = user.clients.kept

        expect(not_deleted_clients).to be_empty
      end

      it "undiscard all clients associated with the user" do
        user = create(:user)
        clients = create_list(:client, 5, user:)

        user.discard
        user.undiscard
        deleted_clients = user.clients.discarded

        expect(deleted_clients).to be_empty
      end
    end
  end
end