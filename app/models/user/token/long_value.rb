# frozen_string_literal: true

class User::Token::LongValue
  include Solid::Value

  LENGTH = 32
  MASKED = "X" * LENGTH

  attribute :string, default: -> { SecureRandom.base58(LENGTH) }

  after_initialize do
    self.value = MASKED if value.blank?
  end

  validates presence: true, length: {is: LENGTH}
end
