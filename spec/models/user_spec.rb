require "rails_helper"

RSpec.describe User, type: :model do
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
end