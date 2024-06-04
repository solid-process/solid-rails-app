# frozen_string_literal: true

module User::Token
  class Creation < Solid::Process
    deps do
      attribute :repository, default: Repository

      validates :repository, respond_to: [:find_by_user, :create!]
    end

    input do
      attribute :user
      attribute :token, default: -> { User::Token::Entity.generate }

      validates :user, instance_of: User::Entity, is: :persisted?
      validates :token, instance_of: User::Token::Entity
    end

    def call(attributes)
      Given(attributes)
        .and_then(:check_token_existance)
        .and_then(:create_token_if_not_exists)
        .and_expose(:token_created, [:token])
    end

    private

    def check_token_existance(user:, **)
      case deps.repository.find_by_user(id: user.id)
      in Solid::Failure then Continue()
      in Solid::Success(token:) then Success(:token_already_exists, token:)
      end
    end

    def create_token_if_not_exists(user:, token:, **)
      case deps.repository.create!(user:, token:)
      in Solid::Failure(token:) then Failure(:invalid_token, token:)
      in Solid::Success(token:) then Continue(token:)
      end
    end
  end
end
