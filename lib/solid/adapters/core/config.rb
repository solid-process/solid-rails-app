# frozen_string_literal: true

module Solid::Adapters::Core
  module Config
    singleton_class.send(:attr_accessor, :proxy_enabled, :interface_enabled)

    self.proxy_enabled = true
    self.interface_enabled = true

    def self.proxy_enabled?
      proxy_enabled
    end

    def self.interface_enabled?
      interface_enabled
    end

    def self.options
      {
        proxy_enabled: proxy_enabled,
        interface_enabled: interface_enabled
      }
    end
  end
end
