require_relative 'test_helper'

module AdequateSerializer
  class CollectionTest < Minitest::Spec
    def test_collection_serialization
      peggy = Person.new(id: 1, name: 'Peggy')
      edwin = Person.new(id: 2, name: 'Edwin')
      expected = { people: [
        TestSerializer.new(peggy, root: false).as_json,
        TestSerializer.new(edwin, root: false).as_json
      ]}

      Collection.new([peggy, edwin], serializer: TestSerializer).as_json
        .must_equal expected
    end

    def test_collection_serialization_without_serializer_class
      peggy = Person.new(id: 1, name: 'Peggy', occupation: 'Agent')
      edwin = Person.new(id: 2, name: 'Edwin', occupation: 'Butler')
      expected = { people: [
        PersonSerializer.new(peggy, root: false).as_json,
        PersonSerializer.new(edwin, root: false).as_json
      ]}

      Collection.new([peggy, edwin]).as_json.must_equal expected
    end
  end
end
