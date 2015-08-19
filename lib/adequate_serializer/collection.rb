require 'active_support/inflector'
require 'adequate_serializer/helper'

module AdequateSerializer
  class Collection
    include Helper

    attr_accessor :collection, :includes, :root, :serializer

    def initialize(collection, includes: nil, root: nil, serializer: nil)
      @collection = collection
      @includes = includes
      @root = root
      @serializer = serializer
    end

    def as_json(options = {})
      data = collection.map do |item|
        serialize(item, includes: includes, root: false, serializer: serializer)
      end

      if root == false
        data
      else
        { root_name => data }
      end
    end

    private

    def root_name
      (root || build_root).to_sym
    end

    def build_root
      if collection.respond_to?(:klass)
        klass = collection.klass
      else
        klass = collection.first.class
      end

      klass == NilClass ? 'nil' : klass.name.underscore.parameterize.pluralize
    end
  end
end
