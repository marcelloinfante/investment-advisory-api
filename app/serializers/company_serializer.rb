class CompanySerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :id, :name
end