# frozen_string_literal: true

class User::Password::SendingResetInstructions < Solid::Process
  deps do
    attribute :mailer, default: -> { User::Adapters.mailer }
    attribute :repository, default: -> { User::Adapters.repository }
    attribute :temporary_token, default: -> { User::Adapters.temporary_token }

    validates :mailer, kind_of: User::Adapters::MailerInterface
    validates :repository, kind_of: User::Adapters::RepositoryInterface
    validates :temporary_token, kind_of: User::Adapters::TemporaryTokenInterface
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
      token = deps.temporary_token.to(:reset_password, user)

      deps.mailer.send_reset_password(token:, email: user.email)

      Success(:resetting_instructions_sent)
    end
  end
end
