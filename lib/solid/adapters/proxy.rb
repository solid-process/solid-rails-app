# frozen_string_literal: true

module Solid::Adapters
  class Proxy < Core::Proxy::Base
    AlwaysEnabled = ::Class.new(Core::Proxy::Base)

    def self.new(object)
      Core::Config.proxy_enabled ? super : object
    end
  end
end
