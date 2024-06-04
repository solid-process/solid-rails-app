# frozen_string_literal: true

class User::Password::Updating < Solid::Process
  deps do
    attribute :repository, default: -> { User::Adapters.repository }

    validates :repository, respond_to: [:update_password]
  end

  input do
    attribute :user
    attribute :password, :string
    attribute :password_confirmation, :string
    attribute :current_password, :string, default: ""

    validates :user, instance_of: User::Entity, is: :persisted?

    with_options presence: true, length: {minimum: User::Password::MINIMUM_LENGTH} do
      validates :password, confirmation: true
      validates :current_password
    end
  end

  def call(attributes)
    case deps.repository.update_password(**attributes)
    in Solid::Success(user:)
      Success(:password_updated, user:)
    in Solid::Failure(user:)
      input.errors.merge!(user.errors)

      Failure(:invalid_input, input:)
    end
  end
end
