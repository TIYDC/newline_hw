require_relative "runners/base"
require_relative "runners/ruby"
require_relative "runners/javascript"

module NewlineHw
  module Shell
    ##
    # Generate a series of language specfic commands to start a project up
    class Run
      attr_reader :pwd, :config
      def initialize(pwd, config)
        @pwd = pwd
        @config = config
      end

      def cmd
        commands = []
        commands += Runners::Ruby.get_commands(pwd)
        commands += Runners::Javascript.get_commands(pwd)
        commands << "#{config.editor} ." if config.launch_editor
        commands.join(" && ")
      end
    end
  end
end
