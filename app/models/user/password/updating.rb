# frozen_string_literal: true

class User::Password::Updating < Solid::Process
  MAP_USER_ATTRIBUTE = -> { (_1 == :password_challenge) ? :current_password : _1 }

  input do
    attribute :user
    attribute :password, :string
    attribute :password_confirmation, :string
    attribute :current_password, :string, default: ""

    validates :user, instance_of: User, persisted: true
    validates :password, User::Password::VALIDATIONS_WITH_CONFIRMATION
    validates :current_password, User::Password::VALIDATIONS
  end

  def call(attributes)
    attributes => {user:, password:, password_confirmation:, current_password: password_challenge}

    if user.update(password:, password_confirmation:, password_challenge:)
      Success(:password_updated, user:)
    else
      user.errors.each { input.errors.import(_1, attribute: MAP_USER_ATTRIBUTE[_1.attribute]) }

      Failure(:invalid_input, input:)
    end
  end
end
