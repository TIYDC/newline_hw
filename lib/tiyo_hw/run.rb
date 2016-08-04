module TiyoHw
  class Run
    def initialize(pwd)
      @pwd = pwd
    end

    def rails?
      File.exist?(File.join(@pwd, "bin", "rails"))
    end

    def gemfile?
      File.exist?(File.join(@pwd, "Gemfile"))
    end

    def _rails_commands
      commands = []
      commands << "bin/rake db:setup"
      commands << "bin/rails s & sleep #{SLEEP_TIME} && open http://localhost:3000"
      commands << "bin/rake test"
      commands << "%%" # Reown the rails s process
      commands
    end

    def cmd
      commands = []
      commands << "bundle install" if gemfile?
      commands += _rails_commands if rails?
      commands.join(" && ")
    end
  end
end
