# frozen_string_literal: true

class User::Authentication < Solid::Process
  deps do
    attribute :repository, default: User::Repository

    validates :repository, respond_to: [:find_by_email_and_password]
  end

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
    case deps.repository.find_by_email_and_password(**attributes)
    in Solid::Failure then Failure(:invalid_input, input:)
    in Solid::Success(user:) then Success(:user_authenticated, user:)
    end
  end
end
