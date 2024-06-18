# frozen_string_literal: true

module Solid::Adapters::Core
  module Proxy
    module ClassMethods
      def [](object)
        new(object)
      end

      def to_proc
        ->(object) { new(object) }
      end
    end

    class Base
      extend ClassMethods

      attr_reader :object

      def initialize(object)
        @object = object
      end
    end
  end
end
