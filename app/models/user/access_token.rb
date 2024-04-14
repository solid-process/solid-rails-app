# frozen_string_literal: true

class User::AccessToken
  include Solid::Model

  attribute :value, :string, default: -> { SecureRandom.hex(20) }

  validates :value, length: {is: 40}, format: {with: /\A[0-9a-f]+\z/}

  alias_method :to_s, :value
end
