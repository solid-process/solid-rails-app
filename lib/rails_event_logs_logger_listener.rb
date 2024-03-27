# frozen_string_literal: true

class RailsEventLogsLoggerListener
  include Solid::Result::EventLogs::Listener

  module NestedMessages
    MAP_STEP = lambda do |kind, type, value|
      value_keys = "#{value.keys.join(":, ")}:"
      value_keys = "" if value_keys == ":"

      case type
      when :_given_ then "Given(#{value_keys})"
      when :_continue_ then "Continue(#{value_keys})"
      else "#{kind.capitalize}(:#{type}, #{value_keys})"
      end
    end

    def self.map(event_logs)
      current_event_log_tracking = []

      messages = event_logs[:records].each_with_object([]) do |record, memo|
        current_event_log = record[:current]

        unless current_event_log_tracking.include?(current_event_log[:id])
          current_event_log => {id:, name:, desc:}

          current_event_log_tracking << id

          memo << [id, "##{id} #{name} - #{desc}".chomp("- ")]
        end

        record => { current: { id: }, result: { kind:, type:, value: } }

        method_name = record.dig(:and_then, :method_name)

        step = MAP_STEP[kind, type, value]

        memo << [id, " * #{step} from method: #{method_name}".chomp("from method: ")]
      end

      ids_level_parent = event_logs.dig(:metadata, :ids, :level_parent)

      messages.map { |(id, msg)| "#{"   " * ids_level_parent[id].first}#{msg}" }
    end
  end

  def on_finish(event_logs:)
    messages = NestedMessages.map(event_logs)

    Rails.logger.info messages.join("\n")
  end

  def before_interruption(exception:, event_logs:)
    messages = NestedMessages.map(event_logs)

    Rails.logger.info messages.join("\n")

    bc = ::ActiveSupport::BacktraceCleaner.new
    bc.add_filter { |line| line.gsub(__dir__.sub("/lib", ""), "").sub(/\A\//, "") }
    bc.add_silencer { |line| /lib\/solid\/result/.match?(line) }
    bc.add_silencer { |line| line.include?(RUBY_VERSION) }

    dir = "#{FileUtils.pwd[1..]}/"

    listener_filename = File.basename(__FILE__).chomp(".rb")

    cb = bc.clean(exception.backtrace)
    cb.each { _1.sub!(dir, "") }
    cb.reject! { _1.match?(/block \(\d levels?\) in|in `block in|internal:kernel|#{listener_filename}/) }

    Rails.logger.error "\nException:\n  #{exception.message} (#{exception.class})\n\nBacktrace:\n  #{cb.join("\n  ")}"
  end
end
