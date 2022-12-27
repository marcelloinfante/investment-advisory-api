class ClientSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :id, :first_name, :last_name, :email, :number_of_assets, :total_amount_in_custody
end