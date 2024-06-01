# frozen_string_literal: true

class User::Password::SendingResetInstructions < Solid::Process
  deps do
    attribute :mailer, default: UserMailer

    attribute :repository, default: User::Repository

    validates :repository, respond_to: [:find_by]
  end

  input do
    attribute :email, :string

    before_validation do
      self.email = email.downcase.strip
    end

    validates :email, presence: true, format: User::Email::REGEXP
  end

  def call(attributes)
    case deps.repository.find_by(**attributes)
    in Solid::Failure then Failure(:email_not_found)
    in Solid::Success(user:)
      deps.mailer.with(
        user: user,
        token: user.generate_token_for(:reset_password)
      ).reset_password.deliver_later

      Success(:resetting_instructions_sent)
    end
  end
end
