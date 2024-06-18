# frozen_string_literal: true

module User::Adapters::TemporaryTokenInterface
  include Solid::Adapters::Interface

  module Methods
    def to(purpose, user)
      purpose => Symbol
      user => User::Entity

      super.tap { _1 => String }
    end
  end
end
