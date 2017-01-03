require "uri"
require "net/http"
require "json"
require "openssl"
require "newline_cli/api"

module NewlineHw
  class GuiTrigger
    attr_reader :editor
    def initialize(data)
      @newline_submission_id = data["id"]
      @application = data["application"] || "Terminal"
      @editor = data["editor"] || "vim"
    end

    def application
      return "Terminal".freeze unless %w(iTerm2 Terminal).include?(@application)
      @application
    end

    def call
      `osascript -e '#{applescript}'`
    end

    private def applescript
      s = ""
      s += "tell application \"#{application}\" to do script "
      s += "\"EDITOR=#{editor} hw #{@newline_submission_id}\"\n"
      s += "tell application \"#{application}\" to activate"
      s
    end
  end
end
