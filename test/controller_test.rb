require_relative 'test_helper'

class ScopeController
  include AdequateSerializer::Controller

  attr_reader :current_user, :person

  def initialize(user, person)
    @current_user = user
    @person = person
  end

  def show
    serialize(person, serializer: ScopedSerializer)
  end
end

class CustomScopeController < ScopeController
  attr_reader :current_agent
  serialization_scope :current_agent

  def initialize(agent, person)
    @current_agent = agent
    @person = person
  end
end

class ScopedSerializer < AdequateSerializer::Base
  attributes :id, :name, :is_colleague

  def is_colleague
    object.colleagues.include?(scope)
  end
end

module AdequateSerializer
  class ControllerTest < Minitest::Spec
    def test_default_scope
      peggy = Person.new
      daniel = Person.new(id: 2, name: 'Daniel')
      daniel.colleagues = [peggy]
      expected = { person: { id: 2, name: 'Daniel', is_colleague: true } }

      ScopeController.new(peggy, daniel).show.must_equal expected
    end

    def test_custom_scope
      peggy = Person.new
      daniel = Person.new(id: 2, name: 'Daniel')
      daniel.colleagues = [peggy]
      expected = { person: { id: 2, name: 'Daniel', is_colleague: true } }

      ScopeController.new(peggy, daniel).show.must_equal expected
    end
  end
end
