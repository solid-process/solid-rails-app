# frozen_string_literal: true

class User::AccessToken::Creation < Solid::Process
  input do
    attribute :user
    attribute :access_token, default: -> { User::AccessToken.new }

    validates :user, instance_of: User, persisted: true
    validates :access_token, instance_of: User::AccessToken
  end

  def call(attributes)
    Given(attributes)
      .and_then(:validate_access_token)
      .and_then(:check_user_token_existance)
      .and_then(:create_token_if_not_exists)
      .and_expose(:token_created, [:token])
  end

  private

  def validate_access_token(access_token:, **)
    access_token.invalid? ? Failure(:invalid_access_token) : Continue()
  end

  def check_user_token_existance(user:, **)
    token = user.token

    token&.persisted? ? Success(:token_already_exists, token:) : Continue()
  end

  def create_token_if_not_exists(user:, access_token:, **)
    token = user.create_token!(access_token:)

    Continue(token:)
  end
end
