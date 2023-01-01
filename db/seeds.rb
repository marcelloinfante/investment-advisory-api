user = FactoryBot.create(:user, email: "test@test.com", first_name: "John", last_name: "Marshal", password: "test123", password_confirmation: "test123")

clients = FactoryBot.create_list(:client, 5, user:)

clients.each do |client|
  assets = FactoryBot.create_list(:asset, 5, client:)
  
  assets.each do |asset|
    FactoryBot.create_list(:simulation, 5, asset:)
  end
end

