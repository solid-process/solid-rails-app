# frozen_string_literal: true

require "solid/validators/persisted_validator"
require "solid/validators/respond_to_validator"
require "solid/validators/instance_of_validator"

require "rails_event_logs_logger_listener"

Solid::Result.configuration do |config|
  config.event_logs.listener = RailsEventLogsLoggerListener
end
