require "thor"
module NewlineHw
  class Cli < Thor
    desc "init", "install the hw function into a current terminal session"
    def init
      puts Shell::Function.cmd
    end

    desc "config", "edit your config file in your editor"
    def config
      `#{NewlineHw.config.editor} #{NewlineHw::Config::CONFIG_PATH}`
    end

    desc "install newlinehw config file and chrome adapter",
     "will setup a logging file and a chrome manifest to allow this app to be communicated to by the newline-assistant chrome extension."
    def install
      NewlineHw.make_log_directory
      ChromeManifest.write
      NewlineHw::Config.install_default
      say "Installed a config file to `#{NewlineHw::Config::CONFIG_PATH}`"
      say "Chrome Native Messaging Hook installed for Newline Assistant"
      say ""
      say ("*" * 30) + " YOU MUST!! Add this line to your shell profile " + ("*" * 30), :red
      say '$ eval "$(newline_hw init)"'
      say ("*" * 30), :red
    end

    desc "setup SUBMISSION_ID",
     "generate a shell command to clone and setup a given SUBMISSION_ID"
    option :editor
    def setup_command(submission_id)
      puts Shell::Setup.new(submission_id, config).cmd
    end

    desc "run WORKINGDIR", "generate a shell command to run language and project specfic tasks a given SUBMISSION_ID"
    option :editor
    def run_command(working_dir, _submission_id = nil)
      puts Shell::Run.new(working_dir, config).cmd
    end
    desc "", ""
    option :editor
    option :application
    def gui_trigger(id)
      data = Config.new.config.merge(options).merge(id: id)
      GuiTrigger.new(data).call
    end

    no_commands do
      def exit_on_failure?
        true
      end

      def config
        config = Config.new
        config.update(options)
      end
    end
  end
end
