require_relative "newline_hw/version"
require_relative "newline_hw/run"
require_relative "newline_hw/setup"
require_relative "newline_hw/shell_function"
require_relative "newline_hw/chrome_manifest"
require_relative "newline_hw/gui_trigger"
require_relative "newline_hw/stream_command_handler"
require_relative "newline_hw/stream_processor"
require "active_support/core_ext/string"
module NewlineHw
  SLEEP_TIME = 4
  HOMEWORK_DIR = "~/theironyard/homework".freeze
  # EDITOR = ENV['EDITOR'] || "atom".freeze
  EDITOR = "atom".freeze


  def self.generate_cmd(command, url_or_path = nil)
    return ShellFunction.cmd if command == "init"

    if command == "install-chrome"
      ChromeManifest.write

      return 'Chrome Hook installed'
    end
    return fail_msg("Please enter a valid URL: #{url_or_path.inspect} is not a valid url ") if url_or_path.to_s.blank?

    case command
    when "setup"
      Setup.new(url_or_path).cmd
    when "run"
      Run.new(url_or_path).cmd
    when "gui-trigger"
      GuiTrigger.new(url_or_path).call
    end
  end

  def self.fail_msg(msg)
    "echo '#{msg}'"
  end
end
