require 'rails_helper'

RSpec.describe Asset, type: :model do
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
end
