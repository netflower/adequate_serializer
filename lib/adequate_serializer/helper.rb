module AdequateSerializer
  module Helper
    def serialize(entity, serializer: nil)
      if entity.respond_to?(:each)
        Collection.new(entity, serializer: serializer).as_json
      else
        serializer ||= Object.const_get("#{entity.class}Serializer")
        serializer.new(entity).as_json
      end
    end
  end
end
