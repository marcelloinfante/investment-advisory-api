require "rails_helper"

RSpec.describe SerializerHelper do
  class ExampleOneObject
    include SerializerHelper

    def serializable_hash
      { data: { attributes: { a: 1, b: 2 } } }
    end
  end

  class ExampleTwoObject
    include SerializerHelper

    def serializable_hash
      { data: [{ attributes: { a: 1, b: 2 } }, { attributes: { a: 1, b: 2 } }] }
    end
  end

  describe "sanitized_hash" do
    it "one object serialized" do
      example = ExampleOneObject.new.sanitized_hash

      expect(example).to eq({"a"=>1, "b"=>2})
    end

    it "two or more objects serialized" do
      example = ExampleTwoObject.new.sanitized_hash

      expect(example).to eq([{"a"=>1, "b"=>2}, {"a"=>1, "b"=>2}])
    end
  end
end