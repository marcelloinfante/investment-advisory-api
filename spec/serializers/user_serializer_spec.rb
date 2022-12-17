require "rails_helper"

RSpec.describe UserSerializer do
  context "serialized hash" do
    it "return serialized user" do
      user = create(:user)
      serialized_user = UserSerializer.new(user).sanitized_hash

      expect(serialized_user).to include({
        name: user.name,
        email: user.email
      })
    end
  end
end