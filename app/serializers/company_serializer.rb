class CompanySerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attribute :name
end