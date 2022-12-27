require 'rails_helper'

RSpec.describe Simulation, type: :model do
  describe "validations" do
    context "presence" do
      it { should validate_presence_of(:agio) }
      it { should validate_presence_of(:market_rate) }
      it { should validate_presence_of(:average_cdi) }
      it { should validate_presence_of(:curve_volume) }
      it { should validate_presence_of(:days_in_years) }
      it { should validate_presence_of(:new_asset_code) }
      it { should validate_presence_of(:new_asset_issuer) }
      it { should validate_presence_of(:quotation_date) }
      it { should validate_presence_of(:new_asset_remaining_years) }
      it { should validate_presence_of(:agio_percentage) }
      it { should validate_presence_of(:final_variation) }
      it { should validate_presence_of(:remaining_years) }
      it { should validate_presence_of(:market_redemption) }
      it { should validate_presence_of(:current_final_value) }
      it { should validate_presence_of(:current_final_value) }
      it { should validate_presence_of(:new_asset_duration) }
      it { should validate_presence_of(:percentage_to_recover) }
      it { should validate_presence_of(:new_asset_minimum_rate) }
      it { should validate_presence_of(:new_asset_maximum_rate) }
      it { should validate_presence_of(:new_asset_suggested_rate) }
      it { should validate_presence_of(:new_asset_indicative_rate) }
      it { should validate_presence_of(:new_asset_expiration_date) }
      it { should validate_presence_of(:new_rate_final_value_same_period) }
      it { should validate_presence_of(:new_rate_final_value_new_period) }
    end
  end
end
