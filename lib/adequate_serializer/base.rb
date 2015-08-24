require 'active_support/inflector'
require 'adequate_serializer/helper'

module AdequateSerializer
  class Base
    include Helper

    class << self
      attr_accessor :_associations
      attr_accessor :_attributes
    end

    def self.inherited(base)
      base._associations = (_associations || []).dup
      base._attributes = (_attributes || []).dup
    end

    def self.attributes(*attributes)
      attributes.each do |attribute|
        @_attributes << attribute

        define_method_for(attribute)
      end
    end

    def self.associations(*associations)
      associations.each do |association|
        @_associations << association
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
      all_associations = self.class._associations | Array(includes)
      serialize_multiple_associations(all_associations)
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
      associated_objects = associated_objects(association_key)

      unless associated_objects.nil?
        serialize(associated_objects, root: false)
      end
    end

    def associated_objects(association_key)
      if respond_to?(association_key)
        send(association_key)
      else
        object.send(association_key)
      end
    end
  end
end
