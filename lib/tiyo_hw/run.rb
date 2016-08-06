require "./lib/tiyo_hw/runners/base"
require "./lib/tiyo_hw/runners/ruby"
require "./lib/tiyo_hw/runners/javascript"

module TiyoHw
  class Run
    attr_reader :pwd
    def initialize(pwd)
      @pwd = pwd
    end

    def cmd
      commands = []
      commands += TiyoHw::Runners::Ruby.get_commands(pwd)
      commands += TiyoHw::Runners::Javascript.get_commands(pwd)
      commands.join(" && ")
    end
  end
end
