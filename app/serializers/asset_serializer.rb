class AssetSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :id, :code, :issuer, :rate_index, :entrance_rate, :quantity

  attribute :application_date do |asset|
    asset[:application_date].to_i
  end

  attribute :expiration_date do |asset|
    asset[:expiration_date].to_i
  end
end