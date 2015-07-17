$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'adequate_serializer'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'

class Model
  def initialize(attributes = {})
    @attributes = attributes
  end

  def read_attribute(name)
    @attributes[name]
  end
end

class Person < Model
end

class TestSerializer < AdequateSerializer::Base
  attributes :id, :name
end
