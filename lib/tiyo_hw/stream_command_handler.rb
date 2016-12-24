require "json"

module TiyoHw
  class StreamCommandHandler
    attr_reader :command, :payload
    def initialize(command)
      @command = command["command"]
      @payload = command["payload"]
    end

    def call
      return {status: :fail, message: "no command found"} unless command
      begin
        {status: :ok, message: GuiTrigger.new(payload).call}
      rescue StandardError => e
        return {status: :fail, message: e.message}
      end
    end
  end
end
