user = FactoryBot.create(:user, email: "marcelloinfante@gmail.com", first_name: "Marcello", last_name: "Infante", password: "test123", password_confirmation: "test123")

clients = FactoryBot.create_list(:client, 5, user:)

clients.each do |client|
  assets = FactoryBot.create_list(:asset, 5, client:)
  
  assets.each do |asset|
    params = FactoryBot.attributes_for(:simulation)
    params[:asset] = asset
    params[:quotation_date] = params[:quotation_date].to_s
    params[:new_asset_expiration_date] = params[:new_asset_expiration_date].to_s

    interector = Simulation::BuildAttributes.call(params:)

    if interector.success?
      Simulation.create!(interector.result)
    end
  end
end

