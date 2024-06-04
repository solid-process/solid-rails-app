# frozen_string_literal: true

Rails.application.config.after_initialize do
  freeze = Rails.env.production?

  User::Adapters.configuration(freeze:) do |config|
    config.mailer = User::MailerAdapter.new
    config.repository = User::RepositoryAdapter
    config.temporary_token = User::TemporaryTokenAdapter.new
  end

  User::Token::Adapters.configuration(freeze:) do |config|
    config.repository = User::Token::RepositoryAdapter
  end
end
