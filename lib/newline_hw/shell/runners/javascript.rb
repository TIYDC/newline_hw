module NewlineHw
  module Shell
    module Runners
      ##
      # Build a shell command that is dependent on files of a project being
      # present that are UNOPINIONATED about how to setup / start a JS project
      class Javascript < Base
        def npm?
          file?("package.json")
        end

        def yarn?
          file?("yarn.lock")
        end

        def prepare_commands
          add_command "yarn" if yarn?
          add_command "npm install" if npm? && !yarn?
        end
      end
    end
  end
end
