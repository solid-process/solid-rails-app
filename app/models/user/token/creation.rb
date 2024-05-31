# frozen_string_literal: true

class User::Token::Creation < Solid::Process
  input do
    attribute :user
    attribute :token, default: -> { User::Token::Entity.generate }

    validates :user, instance_of: User::Record, is: :persisted?
    validates :token, instance_of: User::Token::Entity
  end

  def call(attributes)
    Given(attributes)
      .and_then(:validate_token)
      .and_then(:check_token_existance)
      .and_then(:create_token_if_not_exists)
      .and_expose(:token_created, [:token])
  end

  private

  def validate_token(token:, **)
    token.invalid? ? Failure(:invalid_token, token:) : Continue()
  end

  def check_token_existance(user:, **)
    token = user.token

    token&.persisted? ? Success(:token_already_exists, token:) : Continue()
  end

  def create_token_if_not_exists(user:, token:, **)
    user.create_token!(short: token.short.value, checksum: token.checksum)

    Continue(token:)
  end
end
