require "json"

module NewlineHw
  class StreamCommandHandler
    attr_reader :event, :data, :message_at
    def initialize(event)
      @event = event["event"].to_sym
      @data = event["data"]
      @message_at = event["message_at"].to_i
    end

    def call
      begin
        case @event
        when :heartbeat
          {
            status: :ok,
            message_at: message_at,
            data: {
              version: NewlineHw::VERSION,
              ruby_version: RUBY_VERSION
            }
          }
        when :clone_and_open_submission
          { status: :ok, message_at: message_at, data: GuiTrigger.new(data).call }
        else
          { event: @event, message_at: message_at, status: :fail, message: "no event handler found in Stream Command Handler" }
        end

      rescue StandardError => e
        return { event: @event, message_at: message_at, status: :fail, data: e.message }
      end
    end
  end
end
