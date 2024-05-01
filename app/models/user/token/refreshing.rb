# frozen_string_literal: true

class User::Token::Refreshing < Solid::Process
  deps do
    attribute :token_generator, default: User::Token::Entity
  end

  input do
    attribute :user

    validates :user, instance_of: User, is: :persisted?
  end

  def call(_)
    attempts ||= 1

    new_token = deps.token_generator.generate

    input.user.token.update!(short: new_token.short.value, checksum: new_token.checksum)

    Success(:token_refreshed, token: new_token)
  rescue ActiveRecord::RecordNotUnique => e
    retry if (attempts += 1) <= 3

    Failure(:cannot_be_refreshed, token:, error: e)
  end
end
