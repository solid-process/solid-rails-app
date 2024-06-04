# frozen_string_literal: true

class User::Token::ShortValue
  include Solid::Value

  LENGTH = 8

  attribute :string, default: -> { SecureRandom.base58(LENGTH) }

  validates presence: true, length: {is: LENGTH}
end
