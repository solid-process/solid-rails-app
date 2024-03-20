class UserMailer < ApplicationMailer
  def reset_password
    mail to: params[:user].email, subject: "Reset your password" do |format|
      format.text { render("mailers/user/reset_password") }
      format.html { render("mailers/user/reset_password") }
    end
  end

  def email_confirmation
    mail to: params[:user].email, subject: "Confirm your email" do |format|
      format.text { render("mailers/user/email_confirmation") }
      format.html { render("mailers/user/email_confirmation") }
    end
  end
end
