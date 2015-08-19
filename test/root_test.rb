require_relative 'test_helper'

module AdequateSerializer
  class RootTest < Minitest::Spec
    def test_default_root
      peggy = Person.new(id: 1, name: 'Peggy')

      TestSerializer.new(peggy).as_json.keys.must_equal [:person]
    end

    def test_default_root_of_array
      peggy = Person.new(id: 1, name: 'Peggy')

      Collection.new([peggy]).as_json.keys.must_equal [:people]
    end

    def test_default_root_of_empty_array
      Collection.new([]).as_json.keys.must_equal [:nil]
    end

    def test_default_root_of_relation
      peggy = Person.new(id: 1, name: 'Peggy')
      relation = Relation.new(Agent, [peggy])

      Collection.new(relation).as_json.keys.must_equal [:agents]
    end

    def test_default_root_of_empty_relation
      relation = Relation.new(Agent, [])

      Collection.new(relation).as_json.keys.must_equal [:agents]
    end

    def test_no_root
      peggy = Person.new(id: 1, name: 'Peggy')

      TestSerializer.new(peggy, root: false).as_json.keys
        .must_equal [:id, :name]
    end

    def test_custom_root
      peggy = Person.new(id: 1, name: 'Peggy')

      TestSerializer.new(peggy, root: :agent).as_json.keys.must_equal [:agent]
    end
  end
end
