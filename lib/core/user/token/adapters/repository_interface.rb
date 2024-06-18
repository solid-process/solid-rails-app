# frozen_string_literal: true

module User::Token::Adapters
  module RepositoryInterface
    include Solid::Adapters::Interface

    module Methods
      def find_by_user(id:)
        id => Integer | String

        super.tap do
          _1 => (
            Solid::Failure(:token_not_found, {}) |
            Solid::Success(:token_found, {token: User::Token::Entity})
          )
        end
      end

      def create!(user:, token:)
        user => User::Entity
        token => User::Token::Entity

        super.tap do
          _1 => (
            Solid::Failure(:invalid_token, {token: User::Token::Entity}) |
            Solid::Success(:token_created, {token: User::Token::Entity})
          )
        end
      end

      def refresh(user:, token:)
        user => User::Entity
        token => User::Token::Entity

        super.tap do
          _1 => (
            Solid::Failure(:invalid_token, {token: User::Token::Entity}) |
            Solid::Failure(:cannot_be_refreshed, {token: User::Token::Entity, error: StandardError}) |
            Solid::Success(:token_refreshed, {token: User::Token::Entity})
          )
        end
      end
    end
  end
end
