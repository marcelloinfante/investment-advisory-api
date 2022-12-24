require 'rails_helper'

RSpec.describe Simulation::FormatAttributes do
  describe "method call" do
    let(:user) { create(:user) }
    let(:client) { create(:client, user:) }
    let(:asset) { create(:asset, client:) }

    let(:simulation) { attributes_for(:simulation) }

    let(:params) do
      {
        asset:,
        average_cdi: simulation[:average_cdi].to_s,
        market_rate: simulation[:market_rate].to_s,
        curve_volume: simulation[:curve_volume].to_s,
        quotation_date: simulation[:quotation_date].to_s,
        new_asset_code: simulation[:new_asset_code],
        volume_applied: simulation[:volume_applied].to_s,
        new_asset_issuer: simulation[:new_asset_issuer],
        market_redemption: simulation[:market_redemption].to_s,
        new_asset_duration: simulation[:new_asset_duration].to_s,
        new_asset_minimum_rate: simulation[:new_asset_minimum_rate].to_s,
        new_asset_maximum_rate: simulation[:new_asset_maximum_rate].to_s,
        new_asset_suggested_rate: simulation[:new_asset_suggested_rate].to_s,
        new_asset_indicative_rate: simulation[:new_asset_indicative_rate].to_s,
        new_asset_expiration_date: simulation[:new_asset_indicative_rate].to_s
      }
    end

    context "success case" do
      it "validate attributes" do
        interactor = Simulation::ValidateAttributes.call(params:)

        expect(interactor).to be_success
      end
    end

    context "failure case" do
      let(:interactor) { Simulation::ValidateAttributes.call(params:) }

      context "asset not provided" do
        before(:each) do
          params.delete(:asset)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ asset: "Can't be blank" })
        end
      end

      context "average_cdi not provided" do
        before(:each) do
          params.delete(:average_cdi)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ average_cdi: "must have type String, not NilClass" })
        end
      end

      context "market_rate not provided" do
        before(:each) do
          params.delete(:market_rate)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ market_rate: "must have type String, not NilClass" })
        end
      end
      
      context "curve_volume not provided" do
        before(:each) do
          params.delete(:curve_volume)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ curve_volume: "must have type String, not NilClass" })
        end
      end
      
      context "quotation_date not provided" do
        before(:each) do
          params.delete(:quotation_date)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ quotation_date: "must have type String, not NilClass" })
        end
      end
      
      context "new_asset_code not provided" do
        before(:each) do
          params.delete(:new_asset_code)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ new_asset_code: "must have type String, not NilClass" })
        end
      end
      
      context "volume_applied not provided" do
        before(:each) do
          params.delete(:volume_applied)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ volume_applied: "must have type String, not NilClass" })
        end
      end
      
      context "new_asset_issuer not provided" do
        before(:each) do
          params.delete(:new_asset_issuer)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ new_asset_issuer: "must have type String, not NilClass" })
        end
      end
      
      context "market_redemption not provided" do
        before(:each) do
          params.delete(:market_redemption)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ market_redemption: "must have type String, not NilClass" })
        end
      end
      
      context "new_asset_duration not provided" do
        before(:each) do
          params.delete(:new_asset_duration)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ new_asset_duration: "must have type String, not NilClass" })
        end
      end
      
      context "new_asset_minimum_rate not provided" do
        before(:each) do
          params.delete(:new_asset_minimum_rate)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ new_asset_minimum_rate: "must have type String, not NilClass" })
        end
      end

      context "new_asset_maximum_rate not provided" do
        before(:each) do
          params.delete(:new_asset_maximum_rate)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ new_asset_maximum_rate: "must have type String, not NilClass" })
        end
      end

      context "new_asset_suggested_rate not provided" do
        before(:each) do
          params.delete(:new_asset_suggested_rate)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ new_asset_suggested_rate: "must have type String, not NilClass" })
        end
      end

      context "new_asset_indicative_rate not provided" do
        before(:each) do
          params.delete(:new_asset_indicative_rate)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ new_asset_indicative_rate: "must have type String, not NilClass" })
        end
      end

      context "new_asset_expiration_date not provided" do
        before(:each) do
          params.delete(:new_asset_expiration_date)
        end

        it "interactor fail" do
          expect(interactor).to be_failure
        end

        it "return message error" do
          expect(interactor.error).to eq({ new_asset_expiration_date: "must have type String, not NilClass" })
        end
      end
    end
  end
end