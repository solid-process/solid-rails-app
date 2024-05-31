# frozen_string_literal: true

class User::Authentication < Solid::Process
  input do
    attribute :email, :string
    attribute :password, :string

    before_validation do
      self.email = email.downcase.strip
    end

    with_options presence: true do
      validates :email, format: User::Email::REGEXP
      validates :password, length: {minimum: User::Password::MINIMUM_LENGTH}
    end
  end

  def call(attributes)
    user = User::Record.authenticate_by(attributes)

    user ? Success(:user_authenticated, user:) : Failure(:invalid_input, input:)
  end
end
