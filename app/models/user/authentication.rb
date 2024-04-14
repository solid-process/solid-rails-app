# frozen_string_literal: true

class User::Authentication < Solid::Process
  input do
    attribute :email, :string
    attribute :password, :string

    before_validation do
      self.email = User::Email::NORMALIZATION[email]
    end

    validates :email, User::Email::VALIDATIONS
    validates :password, User::Password::VALIDATIONS
  end

  def call(attributes)
    user = User.authenticate_by(attributes)

    user ? Success(:user_authenticated, user:) : Failure(:invalid_input, input:)
  end
end
