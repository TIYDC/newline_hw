require "uri"
require "net/http"
require "json"
require "openssl"
require "newline_cli/api"

module NewlineHw
  class GuiTrigger
    TERMINAL_TO_TRIGGER = "Terminal".freeze

    def initialize(newline_submission_id)
      @newline_submission_id = newline_submission_id
    end

    def call
      `osascript -e '#{applescript}'`
    end

    private def applescript
      s = ""
      s += "tell application \"#{TERMINAL_TO_TRIGGER}\" to do script "
      s += "\"hw #{@newline_submission_id}\"\n"
      s += "tell application \"#{TERMINAL_TO_TRIGGER}\" to activate"
      s
    end
  end
end
