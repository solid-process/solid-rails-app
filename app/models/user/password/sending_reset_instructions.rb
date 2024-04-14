# frozen_string_literal: true

class User::Password::SendingResetInstructions < Solid::Process
  input do
    attribute :email, :string

    before_validation do
      self.email = User::Email::NORMALIZATION[email]
    end

    validates :email, User::Email::VALIDATIONS
  end

  def call(attributes)
    user = User.find_by(attributes)

    return Failure(:email_not_found) if user.nil?

    UserMailer.with(
      user: user,
      token: user.generate_token_for(:reset_password)
    ).reset_password.deliver_later

    Success(:resetting_instructions_sent)
  end
end
