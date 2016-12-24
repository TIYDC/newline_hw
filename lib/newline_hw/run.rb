require_relative "runners/base"
require_relative "runners/ruby"
require_relative "runners/javascript"

module NewlineHw
  class Run
    attr_reader :pwd
    def initialize(pwd)
      @pwd = pwd
    end

    def cmd
      commands = []
      commands += NewlineHw::Runners::Ruby.get_commands(pwd)
      commands += NewlineHw::Runners::Javascript.get_commands(pwd)
      commands.join(" && ")
    end
  end
end
