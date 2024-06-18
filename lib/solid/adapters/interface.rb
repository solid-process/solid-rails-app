# frozen_string_literal: true

require "delegate"

module Solid::Adapters
  module Interface
    METHODS_FROM = ->(interface) { (RUBY_VERSION > "2.7") ? interface : interface::Methods }

    module Callbacks
      def extended(impl)
        impl.singleton_class.prepend(METHODS_FROM[self])
      end

      def included(impl)
        impl.prepend(METHODS_FROM[self])
      end
    end

    module ClassMethods
      def [](object)
        const_get(:Proxy, false).new(object)
      end
    end

    module ProxyDisabled
      extend Core::Proxy::ClassMethods

      def self.new(object)
        object
      end
    end

    DEFINE = lambda do |interface, enabled:|
      proxy = ProxyDisabled

      if enabled
        proxy = ::Class.new(::SimpleDelegator)
        proxy.extend(Core::Proxy::ClassMethods)
        proxy.prepend(METHODS_FROM[interface])

        interface.extend(Callbacks)
      end

      interface.const_set(:Proxy, proxy)

      interface.extend(ClassMethods)
    end

    def self.included(interface)
      DEFINE[interface, enabled: Core::Config.interface_enabled]
    end

    module AlwaysEnabled
      def self.included(interface)
        DEFINE[interface, enabled: true]
      end
    end

    private_constant :METHODS_FROM, :Callbacks, :ClassMethods, :ProxyDisabled, :DEFINE
  end
end
