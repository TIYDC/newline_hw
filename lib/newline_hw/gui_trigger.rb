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
      @application = data["application"]
    end

    def application
      return "Terminal".freeze unless %w(iTerm2 Terminal).include?(@application)
      @application
    end

    def call
      applescript = case application
      when  "iTerm2"
        applescript_for_iterm
      else
        applescript_for_terminal
      end
      puts applescript
      `osascript -e '#{applescript}'`
    end

    private def command_to_run_in_tty
      "hw #{@newline_submission_id}"
    end

    private def applescript_for_terminal
      <<-APPLESCRIPT
        tell application "#{application}" to do script "#{command_to_run_in_tty}"
        tell application "#{application}" to activate
      APPLESCRIPT
    end

    private def applescript_for_iterm
       <<-APPLESCRIPT
        tell application \"#{application}\"
          set newWindow to (create window with default profile)

          tell current session of newWindow
            write text "#{command_to_run_in_tty}"
          end tell
        end tell
      APPLESCRIPT
    end
  end
end
