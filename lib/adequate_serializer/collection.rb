module AdequateSerializer
  class Collection
    attr_accessor :collection

    def initialize(collection, serializer_klass)
      @collection = collection
      @serializer_klass = serializer_klass
    end

    def as_json
      @collection.map do |item|
        @serializer_klass.new(item).as_json
      end
    end
  end
end
