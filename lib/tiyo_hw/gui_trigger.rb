require 'uri'
require 'net/http'
require 'json'
require 'openssl'
require 'newline_cli/api'

module TiyoHw
  class GuiTrigger
    TERMINAL_TO_TRIGGER ='Terminal'

    def initialize(newline_submission_id)
      @newline_submission_id = newline_submission_id
    end


    def submission_info
      @_submission_info ||= get_submission_info
    end

    def call
      `osascript -e '#{applescript}'`
    end

    private def applescript
      repo = submission_info["url"]
      s = ""
      s += "tell application \"#{TERMINAL_TO_TRIGGER}\" to do script "
      s += "\"hw #{repo}\"\n"
      s += "tell application \"#{TERMINAL_TO_TRIGGER}\" to activate"
      s
    end

    private def get_submission_info
      NewlineCli::Api.new.get("assignment_submissions/#{@newline_submission_id}")
    end
  end
end
