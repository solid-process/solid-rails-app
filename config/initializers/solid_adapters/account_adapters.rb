# frozen_string_literal: true

Rails.application.config.after_initialize do
  freeze = Rails.env.production?

  Account::Member::Adapters.configuration(freeze:) do |config|
    config.repository = Account::Member::RepositoryAdapter
  end

  Account::Task::List::Adapters.configuration(freeze:) do |config|
    config.repository = Account::Task::List::RepositoryAdapter
  end

  Account::Task::Item::Adapters.configuration(freeze:) do |config|
    config.repository = Account::Task::Item::RepositoryAdapter
  end
end
