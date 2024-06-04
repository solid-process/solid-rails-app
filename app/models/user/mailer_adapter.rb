# frozen_string_literal: true

class User::MailerAdapter
  def send_email_confirmation(email:, token:)
    UserMailer.with(email:, token:).email_confirmation.deliver_later
  end

  def send_reset_password(email:, token:)
    UserMailer.with(email:, token:).reset_password.deliver_later
  end
end
