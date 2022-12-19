require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "validations" do
    context "presence" do
      it { should validate_presence_of(:name) }
    end
  end
end
