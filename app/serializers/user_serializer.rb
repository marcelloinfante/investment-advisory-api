class UserSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :name, :email
end