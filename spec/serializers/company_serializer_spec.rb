require "rails_helper"

RSpec.describe CompanySerializer do
  context "serialized hash" do
    it "return serialized company" do
      company = create(:company)
      serialized_company = CompanySerializer.new(company).sanitized_hash

      expect(serialized_company).to include({ name: company.first_name })
    end
  end
end