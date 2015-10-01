require 'adequate_serializer/helper'

module AdequateSerializer
  module Controller
    include Helper

    alias_method :helper_serialize, :serialize

    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        self._serialization_scope = :current_user
      end
    end

    module ClassMethods
      attr_accessor :_serialization_scope

      def inherited(base)
        base._serialization_scope = _serialization_scope
        super(base)
      end

      def serialization_scope(scope)
        self._serialization_scope = scope
      end
    end

    def serialize(entity, options = {})
      options[:scope] = serialization_scope

      helper_serialize(entity, options)
    end

    private

    def serialization_scope
      scope = self.class._serialization_scope

      if scope && respond_to?(scope, true)
        send(scope)
      end
    end
  end
end
