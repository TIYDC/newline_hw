require "json"

module NewlineHw
  class StreamProcessor
    # Don't instant shutdown wait for messages to clear, as chrome is much faster
    # to trigger disconnect callback over wait for succesful messages.
    SHUTDOWN_PAUSE = 0.5
    attr_reader :logger
    def initialize(stdin, stdout, opts = {})
      @logger = opts[:logger]
      @stdin = stdin
      @stdout = stdout
    end

    def on_message(&block)
      loop do
        msg = read_native_message
        sleep(SHUTDOWN_PAUSE) && exit(0) unless msg
        @logger.debug "Receiving Message #{msg} of size:#{msg.length}"
        instance_exec(msg, &block)
      end
    end

    def read_native_message
      # Read signed integer with a max length of 4 bytes.
      text_length_bytes = @stdin.read(4)
      return unless text_length_bytes

      # Unpack bytes in a ruby int.
      text_length = text_length_bytes.unpack("i")[0]
      JSON.parse(@stdin.read(text_length))
    end

    def send_message(message)
      m = message.to_json
      @logger.debug "Sending Message: #{m.length} #{m}"
      @stdout.write [m.length].pack("I")
      @stdout.write(m)
      @stdout.flush
    end
  end
end
