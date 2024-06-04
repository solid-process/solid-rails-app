# frozen_string_literal: true

require "solid/value"

require "solid/validators/is_validator"
require "solid/validators/kind_of_validator"
require "solid/validators/respond_to_validator"
require "solid/validators/instance_of_validator"

require "solid/process/event_logs/basic_logger_listener"

Solid::Process::EventLogs::BasicLoggerListener.logger = Rails.logger

Solid::Result.configuration do |config|
  config.event_logs.listener = Solid::Process::EventLogs::BasicLoggerListener
end
