module User::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password

    generates_token_for :reset_password, expires_in: 15.minutes do
      password_salt&.last(10)
    end

    generates_token_for :email_confirmation, expires_in: 24.hours do
      email
    end

    after_create_commit :send_email_confirmation
  end

  private

  def send_email_confirmation
    UserMailer.with(user: self, token: generate_token_for(:email_confirmation)).email_confirmation.deliver_later
  end
end
