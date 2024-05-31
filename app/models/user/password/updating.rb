# frozen_string_literal: true

class User::Password::Updating < Solid::Process
  MAP_USER_ATTRIBUTE = -> { (_1 == :password_challenge) ? :current_password : _1 }

  input do
    attribute :user
    attribute :password, :string
    attribute :password_confirmation, :string
    attribute :current_password, :string, default: ""

    validates :user, instance_of: User::Record, is: :persisted?

    with_options presence: true, length: {minimum: User::Password::MINIMUM_LENGTH} do
      validates :password, confirmation: true
      validates :current_password
    end
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
