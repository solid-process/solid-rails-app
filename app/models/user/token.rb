# frozen_string_literal: true

module User::Token
  extend Solid::Context

  self.actions = {
    refresh: Refreshing
  }

  def repository = Adapters.repository
end
