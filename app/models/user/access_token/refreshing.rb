# frozen_string_literal: true

class User::AccessToken::Refreshing < Solid::Process
  deps do
    attribute :token_generator, default: User::AccessToken
  end

  input do
    attribute :user

    validates :user, instance_of: User, persisted: true
  end

  def call(_)
    token = input.user.token

    refresh_access_token!(token)

    if token.saved_change_to_access_token?
      Success(:token_refreshed, token:)
    else
      Failure(:cannot_be_refreshed, token:)
    end
  end

  private

  def refresh_access_token!(token)
    3.times do
      token.update!(access_token: deps.token_generator.new.value)

      break if token.saved_change_to_access_token?
    end
  end
end
