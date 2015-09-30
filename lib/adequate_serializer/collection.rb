require 'active_support/inflector'
require 'adequate_serializer/helper'

module AdequateSerializer
  class Collection
    include Helper

    attr_accessor :collection, :root, :collection_options

    def initialize(collection, options = {})
      @collection = collection
      @root = options.delete(:root)
      @collection_options = options
      @collection_options[:root] = false
    end

    def as_json(options = {})
      data = collection.map { |item| serialize(item, collection_options) }

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
