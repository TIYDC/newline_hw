module NewlineHw
  module Shell
    module Runners
      ##
      # Build a shell command that is dependent on files of a project being
      # present that are UNOPINIONATED about how to setup / start a ruby related
      # project
      class Ruby < Base
        def rails?
          file?("bin", "rails")
        end

        def gemfile?
          file?("Gemfile")
        end

        def spring?
          file_contents?(/spring/, "Gemfile.lock")
        end

        def _rails_commands
          add_command "spring stop" if spring?
          add_command "bin/rake db:setup"
          add_command "bin/rake test"
        end

        def prepare_commands
          add_command "bundle install" if gemfile?
          _rails_commands if rails?
        end
      end
    end
  end
end
