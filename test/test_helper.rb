$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'adequate_serializer'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'

class Model
  def initialize(attributes = {})
    @attributes = attributes
  end

  def read_attribute_for_serialization(name)
    @attributes[name]
  end
end

class Person < Model
  attr_accessor :colleagues, :superior
end

class TestSerializer < AdequateSerializer::Base
  attributes :id, :name
end

class PersonSerializer < AdequateSerializer::Base
  attributes :id, :name, :occupation
end

class OverrideAssociationSerializer < AdequateSerializer::Base
  attributes :id, :name

  def colleagues
    object.colleagues.select do |colleague|
      colleague.read_attribute_for_serialization(:id) > 2
    end
  end
end
