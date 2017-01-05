require "thor"
module NewlineHw
  class Cli < Thor
    desc "init", ""
    def init
      puts Shell::Function.cmd
    end

    desc "install newlinehw chrome adapter", "will setup a logging file and a chrome manifest to allow this app to be communicated to by the newline-assistant chrome extension."
    def install
      Dir.mkdir(File.dirname(logfile)) unless Dir.exist?(File.dirname(logfile))
      ChromeManifest.write
      puts "Chrome Hook installed"
    end

    desc "setup SUBMISSION_ID", "generate a shell command to clone and setup a given SUBMISSION_ID"
    option :editor
    def setup_command(submission_id)
      puts Shell::Setup.new(submission_id, options).cmd
    end

    desc "run WORKINGDIR", "generate a shell command to run language and project specfic tasks a given SUBMISSION_ID"
    option :editor
    def run_command(working_dir, _submission_id = nil)
      puts Shell::Run.new(working_dir, options).cmd
    end
    desc "", ""
    option :editor
    option :application
    def gui_trigger(id)
      data = options.merge(id: id)
      GuiTrigger.new(data).call
    end
    no_commands do
      def exit_on_failure?
        true
      end
    end
  end
end
