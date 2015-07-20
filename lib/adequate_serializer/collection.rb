require 'adequate_serializer/helper'

module AdequateSerializer
  class Collection
    include Helper

    attr_accessor :collection, :serializer

    def initialize(collection, serializer: nil)
      @collection = collection
      @serializer = serializer
    end

    def as_json
      collection.map do |item|
        serialize(item, serializer: serializer)
      end
    end
  end
end
