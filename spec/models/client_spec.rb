require 'rails_helper'

RSpec.describe Client, type: :model do
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
end
