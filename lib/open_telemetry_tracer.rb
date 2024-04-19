class OpenTelemetryTracer
  include Solid::Result::EventLogs::Listener
  SolidResultTracer = ::OpenTelemetry.tracer_provider.tracer("solid-result")

  def self.around_event_logs?
    true
  end

  def self.around_and_then?
    true
  end

  def around_event_logs(scope:, &)
    SolidResultTracer.in_span("#{scope[:name]}#call", attributes: {
      "desc" => scope[:desc]
    }, &)
  end

  def around_and_then(scope:, and_then:, **, &)
    SolidResultTracer.in_span("#{scope[:name]}##{and_then[:method_name] || "block"}", attributes: {
      "type" => and_then[:type],
      "arg" => and_then[:arg].inspect
    }, &)
  end
end
