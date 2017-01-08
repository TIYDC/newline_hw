require "json"

module NewlineHw
  ##
  # A json message handler to trigger actions from chrome native messaging
  class StreamCommandHandler
    attr_reader :event, :data, :message_at
    EVENTS = [
      :heartbeat,
      :clone_and_open_submission,
      :check_if_cloneable
    ].freeze

    def initialize(event)
      @event = event["event"].to_sym
      @data = event["data"]
      @message_at = event["message_at"].to_i
    end

    def known_event?
      EVENTS.include?(event)
    end

    def call
      return handle_unknown unless known_event?
      send(event)

    rescue StandardError => e
      handle_fail(e)
    end

    def heartbeat
      {
        status: :ok,
        message_at: message_at,
        data: {
          version: NewlineHw::VERSION,
          newline_cli_version: NewlineCli::VERSION,
          ruby_version: RUBY_VERSION,
          config_path: Config::CONFIG_PATH
        }
      }
    end

    def check_if_cloneable
      setup = Shell::Setup.new(data["id"], Config.new)
      {
        status: :ok,
        message_at: message_at,
        data: {
          cloneable: setup.cloneable?,
          submission_info: setup.submission_info
        }
      }
    end

    def clone_and_open_submission
      {
        status: :ok,
        message_at: message_at,
        data: GuiTrigger.new(data, Config.new).call
      }
    end

    def handle_unknown
      {
        status: :fail,
        message_at: message_at,
        message: \
          "no event handler found in Stream Command Handler for #{@event}"
      }
    end

    def handle_fail(e)
      {
        status: :fail,
        event: @event,
        message_at: message_at,
        message: e.message
      }
    end
  end
end
