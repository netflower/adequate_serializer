require 'active_support/inflector'
require 'adequate_serializer/helper'

module AdequateSerializer
  class Base
    include Helper

    class << self
      attr_accessor :_attributes
    end

    def self.inherited(base)
      base._attributes = (_attributes || []).dup
    end

    def self.attributes(*attrs)
      attrs.each do |attr|
        @_attributes << attr

        define_method_for(attr)
      end
    end

    attr_accessor :object, :includes, :root

    def initialize(object, includes: nil, root: nil)
      @object = object
      @includes = includes
      @root = root
    end

    def as_json(options = {})
      hash = attributes
      hash.merge!(associations)

      if root == false
        hash
      else
        { root_name => hash }
      end
    end

    def attributes
      self.class._attributes.each_with_object({}) do |name, hash|
        clean_name = clean_name(name)
        hash[clean_name] = send(name)
      end
    end

    def associations
      return {} if includes.nil?

      if includes.respond_to?(:each)
        serialize_multiple_associations(includes)
      else
        { includes => serialize_association(includes) }
      end
    end

    private

    def self.define_method_for(attr)
      define_method(attr) do
        object && object.read_attribute_for_serialization(attr)
      end
    end

    def root_name
      (root || object.class.name.underscore.parameterize).to_sym
    end

    def clean_name(name)
      name = name.to_s.gsub(/\?\Z/, '')
      name.to_sym
    end

    def serialize_multiple_associations(association_keys)
      association_keys.each_with_object({}) do |key, hash|
        hash[key] = serialize_association(key)
      end
    end

    def serialize_association(association_key)
      associated_objects = object.send(association_key)
      serialize(associated_objects, root: false)
    end
  end
end
