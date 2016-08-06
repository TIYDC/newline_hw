module TiyoHw
  module Runners
    class Ruby < Base
      def rails?
        file?("bin", "rails")
      end

      def gemfile?
        file?("Gemfile")
      end

      def _rails_commands
        add_command "bin/rake db:setup"
        add_command "bin/rails s & sleep #{SLEEP_TIME} && open http://localhost:3000"
        add_command "bin/rake test"
        add_command "%%" # Reown the rails s process
      end

      def prepare_commands
        add_command "bundle install" if gemfile?
        _rails_commands if rails?
      end
    end
  end
end
