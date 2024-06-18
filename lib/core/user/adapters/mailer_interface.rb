# frozen_string_literal: true

module User::Adapters::MailerInterface
  include Solid::Adapters::Interface

  module Methods
    def send_email_confirmation(email:, token:)
      email => String
      token => String

      super
    end

    def send_reset_password(email:, token:)
      email => String
      token => String

      super
    end
  end
end
