require_relative 'test_helper'

module AdequateSerializer
  class Associations < Minitest::Spec
    def test_no_associations
      peggy = Person.new

      PersonSerializer.new(peggy).associations.must_equal({})
    end

    def test_entity_association
      peggy = Person.new
      roger = Person.new(id: 2, name: 'Roger', occupation: 'Chief')
      peggy.superior = roger
      expected = { superior: PersonSerializer.new(roger, root: false).as_json }

      PersonSerializer.new(peggy, includes: :superior).associations
        .must_equal expected
    end

    def test_collection_association
      peggy = Person.new
      daniel = Person.new(id: 3, name: 'Daniel', occupation: 'Agent')
      jack = Person.new(id: 4, name: 'Jack', occupation: 'Agent')
      peggy.colleagues = [daniel, jack]
      expected = {
        colleagues: Collection.new([daniel, jack], root: false).as_json
      }

      PersonSerializer.new(peggy, includes: :colleagues).associations
        .must_equal expected
    end

    def test_multiple_associations
      peggy = Person.new
      roger = Person.new(id: 2, name: 'Roger', occupation: 'Chief')
      peggy.superior = roger
      daniel = Person.new(id: 3, name: 'Daniel', occupation: 'Agent')
      jack = Person.new(id: 4, name: 'Jack', occupation: 'Agent')
      peggy.colleagues = [daniel, jack]
      expected = {
        colleagues: Collection.new([daniel, jack], root: false).as_json,
        superior: PersonSerializer.new(roger, root: false).as_json
      }

      PersonSerializer.new(peggy, includes: [:colleagues, :superior])
        .associations
        .must_equal expected
    end

    def test_nested_associations
      peggy = Person.new
      roger = Person.new(id: 2, name: 'Roger', occupation: 'Chief')
      daniel = Person.new(id: 3, name: 'Daniel', occupation: 'Agent')
      peggy.colleagues = [daniel]
      daniel.superior = roger
      expected = {
        colleagues: Collection.new([daniel], root: false, includes: :superior)
          .as_json
      }

      PersonSerializer.new(peggy, includes: [colleagues: :superior])
        .associations
        .must_equal expected
    end

    def test_default_associations
      peggy = Person.new
      roger = Person.new(id: 2, name: 'Roger', occupation: 'Chief')
      peggy.superior = roger
      daniel = Person.new(id: 3, name: 'Daniel', occupation: 'Agent')
      jack = Person.new(id: 4, name: 'Jack', occupation: 'Agent')
      peggy.colleagues = [daniel, jack]
      expected = {
        colleagues: Collection.new([daniel, jack], root: false).as_json,
        superior: PersonSerializer.new(roger, root: false).as_json
      }

      AssociationsSerializer.new(peggy, includes: [:colleagues, :superior])
        .associations
        .must_equal expected
    end

    def test_association_override
      peggy = Person.new
      daniel = Person.new(id: 1, name: 'Daniel', occupation: 'Agent')
      jack = Person.new(id: 4, name: 'Jack', occupation: 'Agent')
      peggy.colleagues = [daniel, jack]
      expected = {
        colleagues: Collection.new([jack], root: false).as_json
      }

      OverrideAssociationSerializer.new(peggy, includes: :colleagues)
        .associations
        .must_equal expected
    end

    def test_association_is_nil
      peggy = Person.new
      peggy.colleagues = Relation.new(Person, [])
      expected = { superior: nil, colleagues: [] }

      PersonSerializer.new(peggy, includes: [:superior, :colleagues])
        .associations
        .must_equal expected
    end

    def test_no_duplicated_associations
      peggy = Person.new
      peggy.colleagues = Relation.new(Person, [])
      expected = { superior: nil, colleagues: [] }

      AssociationsSerializer.new(peggy, includes: [:superior, :colleagues])
        .associations
        .must_equal expected
    end
  end
end
