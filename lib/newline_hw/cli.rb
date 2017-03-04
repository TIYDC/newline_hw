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
      NewlineHw::Config.install_default
      say "Installed a config file to `#{NewlineHw::Config::CONFIG_PATH}`"
      install_chrome_hook
      say ""
      say ("*" * 30) + " YOU MUST!! Add this line to your shell profile " + ("*" * 30), :red
      say '$ eval "$(newline_hw init)"'
      say ("*" * 30), :red
    end

    desc "update related code", "it runs gem install and updates the chrome hook"
    def upgrade
      `gem install newline_hw && newline_hw install_chrome_hook`
    end

    desc "install chrome adapter",
         "will setup a logging file and a chrome manifest to allow this app to be communicated to by the newline-assistant chrome extension."
    def install_chrome_hook
      NewlineHw.make_log_directory
      begin
        ChromeManifest.write
        say "Chrome Native Messaging Hook installed for Newline Assistant", :green
      rescue Errno::EACCES => e
        path = "~/Library/Application Support/Google/Chrome/NativeMessagingHosts/com.theironyard.newlinecli.hw.json"
        say "Could NOT add chrome native messaging hook please check permissions for #{path} and that containing folder exists with 0600 permissions.", :red
        say "*" * 80
        say ""
        say "   sudo chown -R $(whoami) #{path} "
        say ""
        say "Error Message: #{e.message}"
      end
    end

    desc "remove chrome adaptor, and log files",
         "purge related files "
    def uninstall
      NewlineHw.remove_log_directory
      say "Chrome Messaging Logs REMOVED", :green
      ChromeManifest.remove
      say "Chrome Native Messaging Hook REMOVED", :green
      say "Finish uninstall with these commands"
      say ""
      say "   rm #{NewlineHw::Config::CONFIG_PATH}"
      say "   gem uninstall newline_hw --executables"
      say ""
    end

    desc "setup SUBMISSION_ID",
         "generate a shell command to clone and setup a given SUBMISSION_ID"
    option :editor
    def setup_command(submission_id)
      puts Shell::Setup.new(submission_id, config).cmd
    rescue NewlineCli::AuthenticationError => e
      say "Could not log into Newline using NewlineCLI, have you logged in?"
      say "Error from NewlineCli #{e.message}"
      exit 3
    rescue Excon::Error::Socket => e
      say "Error could not open a connection to newline.  Do you have internet?"
      say "Error message #{e.message}"
      exit 3
    rescue Excon::Error::Forbidden => e
      say "You do not have access to this submission."
      say "Error message #{e.message}"
      exit 3
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
      GuiTrigger.new({ id: id }, config).call
    end

    no_commands do
      def exit_on_failure?
        true
      end

      def config
        config = Config.new
        config.update(options)
        config
      end
    end
  end
end
