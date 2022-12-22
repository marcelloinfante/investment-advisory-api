require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "association" do
    it { should have_many(:users) }
  end

  describe "validations" do
    context "presence" do
      it { should validate_presence_of(:name) }
    end
  end

  describe "callbacks" do
    context "discard" do
      it "discard all users associated with the company" do
        company = create(:company)
        users = create_list(:user, 5, company:)

        company.discard
        not_deleted_users = company.users.kept

        expect(not_deleted_users).to be_empty
      end

      it "undiscard all users associated with the company" do
        company = create(:company)
        users = create_list(:user, 5, company:)

        company.discard
        company.undiscard
        deleted_users = company.users.discarded

        expect(deleted_users).to be_empty
      end
    end
  end
end
