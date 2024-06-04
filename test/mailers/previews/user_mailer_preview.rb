# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def reset_password
    UserMailer.with(email: "email@example.com", token: "token").reset_password
  end

  def email_confirmation
    UserMailer.with(email: "email@example.com", token: "token").email_confirmation
  end
end
