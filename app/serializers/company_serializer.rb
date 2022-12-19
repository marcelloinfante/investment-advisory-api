class UserSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attribute :name
end