# frozen_string_literal: true

module Account::Member::Adapters
  extend Solid::Adapters::Configurable

  config.repository = nil

  def self.repository = config.repository
end
