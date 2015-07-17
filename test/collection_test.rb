require_relative 'test_helper'

module AdequateSerializer
  class CollectionTest < Minitest::Spec
    def test_collection_serialization
      peggy = Person.new(id: 1, name: 'Peggy')
      edwin = Person.new(id: 2, name: 'Edwin')
      expected = [
        TestSerializer.new(peggy).as_json,
        TestSerializer.new(edwin).as_json
      ]

      Collection.new([peggy, edwin], TestSerializer).as_json
        .must_equal expected
    end
  end
end
