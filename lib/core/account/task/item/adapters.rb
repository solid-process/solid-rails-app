# frozen_string_literal: true

module Account::Task::Item::Adapters
  extend Solid::Adapters::Configurable

  config.repository = nil

  def self.repository = config.repository
end
