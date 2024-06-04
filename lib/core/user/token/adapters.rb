# frozen_string_literal: true

module User::Token::Adapters
  extend Solid::Adapters::Configurable

  config.repository = nil

  def self.repository = config.repository
end
