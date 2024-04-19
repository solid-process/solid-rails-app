# frozen_string_literal: true

require "solid/validators/persisted_validator"
require "solid/validators/respond_to_validator"
require "solid/validators/instance_of_validator"

require "rails_event_logs_logger_listener"
require "open_telemetry_tracer"

Solid::Result.configuration do |config|
  config.event_logs.listener = Solid::Result::EventLogs::Listeners[
    RailsEventLogsLoggerListener,
    OpenTelemetryTracer
  ]
end
