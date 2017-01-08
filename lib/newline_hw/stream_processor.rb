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
        msg = self.class.read_native_json_message(@stdin)
        sleep(SHUTDOWN_PAUSE) && exit(0) unless msg
        @logger.debug "Receiving Message #{msg} of size:#{msg.length}"
        instance_exec(msg, &block)
      end
    end

    def send_message(message)
      @logger.debug "Sending Message: #{message}"
      self.class.write_message(@stdout, message)
    end

    def self.write_message(io, msg)
      msg = msg.to_json
      io.write [msg.length].pack("I")
      io.write(msg)
      io.flush
    end

    def self.read_native_json_message(io)
      # Read signed integer with a max length of 4 bytes.
      text_length_bytes = io.read(4)
      return unless text_length_bytes

      # Unpack bytes in a ruby int.
      text_length = text_length_bytes.unpack("i")[0]
      text = io.read(text_length)
      JSON.parse(text)
    rescue JSON::ParserError
      puts text
    end
  end
end
