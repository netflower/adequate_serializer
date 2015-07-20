require_relative 'test_helper'

module AdequateSerializer
  class RootTest < Minitest::Spec
    def test_default_root
      peggy = Person.new(id: 1, name: 'Peggy')
      TestSerializer.new(peggy).as_json.keys.must_equal [:person]
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
