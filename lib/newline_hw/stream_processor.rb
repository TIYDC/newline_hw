require "json"

module NewlineHw
  class StreamProcessor
    attr_reader :logger
    def initialize(stdin, stdout, opts = {})
      @logger = opts[:logger]
      @stdin = stdin
      @stdout = stdout
    end

    def on_message(&block)
      loop do
        msg = read_native_message
        exit 0 unless msg
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
