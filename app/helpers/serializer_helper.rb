module SerializerHelper
  def sanitized_hash
    self.serializable_hash[:data][:attributes].with_indifferent_access
  end
end