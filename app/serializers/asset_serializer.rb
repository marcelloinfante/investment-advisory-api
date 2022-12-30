class AssetSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :id, :code, :issuer, :rate_index, :entrance_rate, :quantity, :volume_applied, :application_date, :expiration_date
end