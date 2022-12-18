class UserSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :first_name, :last_name, :email
end