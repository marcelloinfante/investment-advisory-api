module SerializerHelper
  def sanitized_hash
    data = self.serializable_hash[:data]

    if data.class == Array
      data&.map { |obj| obj.dig(:attributes)&.with_indifferent_access }
    else
      data&.dig(:attributes)&.with_indifferent_access
    end
  end
end