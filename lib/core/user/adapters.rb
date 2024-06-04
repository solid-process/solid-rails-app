# frozen_string_literal: true

module User::Adapters
  extend Solid::Adapters::Configurable

  config.mailer = nil
  config.repository = nil
  config.temporary_token = nil

  def self.mailer = config.mailer

  def self.repository = config.repository

  def self.temporary_token = config.temporary_token
end
