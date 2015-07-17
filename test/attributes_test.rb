require_relative 'test_helper'

module AdequateSerializer
  class AttributesTest < Minitest::Spec
    def test_attributes_definition
      TestSerializer._attributes.must_equal [:id, :name]
    end

    def test_attributes_inheritance
      inherited_serializer_klass = Class.new(TestSerializer) do
        attributes :occupation
      end

      attributes = [:id, :name, :occupation]
      inherited_serializer_klass._attributes.must_equal attributes
    end

    def test_attributes_serialization
      peggy = Person.new(id: 1, name: 'Peggy')
      serializer = TestSerializer.new(peggy)

      attributes_hash = { id: 1, name: 'Peggy' }
      serializer.attributes.must_equal attributes_hash
    end
  end
end
