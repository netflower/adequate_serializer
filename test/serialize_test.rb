require_relative 'test_helper'

class DummyClass
  include AdequateSerializer::Helper
end

module AdequateSerializer
  class SerializeTest < Minitest::Spec
    def helper
      @helper ||= DummyClass.new
    end

    def test_serialize_collections_with_serializer
      peggy = Person.new(id: 1, name: 'Peggy')
      edwin = Person.new(id: 2, name: 'Edwin')
      expected = { people: [
        TestSerializer.new(peggy, root: false).as_json,
        TestSerializer.new(edwin, root: false).as_json
      ]}

      helper.serialize([peggy, edwin], serializer: TestSerializer)
        .must_equal expected
    end

    def test_serialize_collections_without_serializer
      peggy = Person.new(id: 1, name: 'Peggy', occupation: 'Agent')
      edwin = Person.new(id: 2, name: 'Edwin', occupation: 'Butler')
      expected = { people: [
        PersonSerializer.new(peggy, root: false).as_json,
        PersonSerializer.new(edwin, root: false).as_json
      ]}

      helper.serialize([peggy, edwin]).must_equal expected
    end

    def test_serialize_objects_with_serializer
      peggy = Person.new(id: 1, name: 'Peggy')
      expected = TestSerializer.new(peggy).as_json

      helper.serialize(peggy, serializer: TestSerializer).must_equal expected
    end

    def test_serialize_objects_without_serializer
      peggy = Person.new(id: 1, name: 'Peggy', occupation: 'Agent')
      expected = PersonSerializer.new(peggy).as_json

      helper.serialize(peggy).must_equal expected
    end
  end
end
