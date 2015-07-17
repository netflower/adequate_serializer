module AdequateSerializer
  class Base
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

    attr_accessor :object

    def initialize(object)
      @object = object
    end

    def as_json
      { data: attributes }
    end

    def attributes
      self.class._attributes.each_with_object({}) do |name, hash|
        hash[name] = send(name)
      end
    end

    private

    def self.define_method_for(attr)
      define_method(attr) do
        object && object.read_attribute(attr)
      end
    end
  end
end
