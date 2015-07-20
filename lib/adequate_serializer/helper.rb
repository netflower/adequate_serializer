module AdequateSerializer
  module Helper
    def serialize(entity, includes: nil, root: nil, serializer: nil)
      if entity.respond_to?(:each)
        Collection.new(
          entity, includes: includes, root: root, serializer: serializer
        ).as_json
      else
        serializer ||= Object.const_get("#{entity.class}Serializer")
        serializer.new(entity, includes: includes, root: root).as_json
      end
    end
  end
end
