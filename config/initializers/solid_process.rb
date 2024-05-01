# frozen_string_literal: true

require "solid/process/event_logs/basic_logger_listener"

Solid::Process::EventLogs::BasicLoggerListener.logger = Rails.logger

Solid::Result.configuration do |config|
  config.event_logs.listener = Solid::Process::EventLogs::BasicLoggerListener
end
