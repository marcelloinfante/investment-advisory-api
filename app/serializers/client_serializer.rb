class ClientSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :id, :first_name, :last_name, :email
end