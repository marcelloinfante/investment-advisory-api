class AssetSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :code, :issuer, :rate_index, :entrance_rate, :quantity, :application_date, :expiration_date
end