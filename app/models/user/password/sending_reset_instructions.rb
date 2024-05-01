# frozen_string_literal: true

class User::Password::SendingResetInstructions < Solid::Process
  deps do
    attribute :mailer, default: UserMailer
  end

  input do
    attribute :email, :string

    before_validation do
      self.email = email.downcase.strip
    end

    validates :email, presence: true, format: User::Email::REGEXP
  end

  def call(attributes)
    user = User.find_by(attributes)

    return Failure(:email_not_found) if user.nil?

    deps.mailer.with(
      user: user,
      token: user.generate_token_for(:reset_password)
    ).reset_password.deliver_later

    Success(:resetting_instructions_sent)
  end
end
