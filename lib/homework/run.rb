module Homework
  class Run
    def initialize(pwd)
      @pwd = pwd
    end

    def is_rails?
      File.exist?(File.join(@pwd, "bin", "rails"))
    end

    def has_gemfile?
      File.exist?(File.join(@pwd, "Gemfile"))
    end

    def _rails_commands
      commands
      commands << "bin/rake db:setup"
      commands << "bin/rails s & sleep #{SLEEP_TIME} && open http://localhost:3000"
      commands << "bin/rake test && %"
      commands
    end

    def cmd
      commands = []
      commands << "bundle install" if has_gemfile?
      commands + _rails_commands if is_rails?
      commands.join(" && ")
    end
  end
end
