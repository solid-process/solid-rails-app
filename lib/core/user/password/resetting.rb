# frozen_string_literal: true

class User::Password::Resetting < Solid::Process
  deps do
    attribute :repository, default: -> { User::Adapters.repository }

    validates :repository, kind_of: User::Adapters::RepositoryInterface
  end

  input do
    attribute :token, :string
    attribute :password, :string
    attribute :password_confirmation, :string

    with_options presence: true do
      validates :token
      validates :password, confirmation: true, length: {minimum: User::Password::MINIMUM_LENGTH}
    end
  end

  def call(attributes)
    result = deps.repository.reset_password(**attributes)

    case result
    in Solid::Success(user:)
      Success(:password_updated, user:)
    in Solid::Failure(:invalid_or_expired_token, _)
      Failure(:user_not_found)
    in Solid::Failure(user:)
      input.errors.merge!(user.errors)

      Failure(:invalid_input, input:)
    end
  end
end
