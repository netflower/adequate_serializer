module AdequateSerializer
  module Helper
    def serialize(entity, options = {})
      if entity.respond_to?(:each)
        serializer = Collection
      else
        serializer = options[:serializer] || serializer_klass(entity)
      end

      serializer.new(entity, options).as_json
    end

    private

    def serializer_klass(entity)
      Object.const_get("#{entity.class}Serializer")
    end
  end
end
