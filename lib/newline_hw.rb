require_relative "newline_hw/version"
require_relative "newline_hw/config"
require_relative "newline_hw/shell/run"
require_relative "newline_hw/shell/setup"
require_relative "newline_hw/shell/function"
require_relative "newline_hw/chrome_manifest"
require_relative "newline_hw/gui_trigger"
require_relative "newline_hw/stream_command_handler"
require_relative "newline_hw/stream_processor"
require "newline_cli"
require "newline_cli/api"
require "newline_cli/token"
require "newline_cli/error"
require "newline_cli/auth"
require "active_support/core_ext/string"

module NewlineHw
  SLEEP_TIME = 4

  module_function

  def config
    Config.new
  end

  def root_path
    File.expand_path("../..", __FILE__)
  end

  def logfile
    File.expand_path config.log_file
  end

  def make_log_directory
    return if Dir.exist?(File.dirname(NewlineHw.logfile))
    Dir.mkdir(File.dirname(NewlineHw.logfile))
  end

  def remove_log_directory
    return unless Dir.exist?(File.dirname(NewlineHw.logfile))
    FileUtils.remove_dir(File.dirname(NewlineHw.logfile))
  end
end
