# frozen_string_literal: true

module User::Token
  class Refreshing < Solid::Process
    MAXIMUM_ATTEMPTS = 3

    deps do
      attribute :token_generator, default: User::Token::Entity

      attribute :repository, default: -> { Adapters.repository }

      validates :repository, respond_to: [:refresh]
    end

    input do
      attribute :user

      validates :user, instance_of: User::Entity, is: :persisted?
    end

    def call(attributes)
      MAXIMUM_ATTEMPTS.times do |attempts|
        new_token = deps.token_generator.generate

        case deps.repository.refresh(token: new_token, user: attributes[:user])
        in Solid::Success(token:)
          break Success(:token_refreshed, token:)
        in Solid::Failure(token:) if token.errors.any?
          break Failure(:invalid_token, token:)
        in Solid::Failure(token:, error:)
          break Failure(:cannot_be_refreshed, token:, error:) if attempts < MAXIMUM_ATTEMPTS
        end
      end
    end
  end
end
