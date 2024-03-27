# frozen_string_literal: true

require "rails_event_logs_logger_listener"

Solid::Result.configuration do |config|
  config.event_logs.listener = RailsEventLogsLoggerListener
end
