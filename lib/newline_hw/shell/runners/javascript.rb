module NewlineHw
  module Shell
    module Runners
      class Javascript < Base
        def npm?
          file?("package.json")
        end

        def prepare_commands
          add_command "npm install" if npm?
        end
      end
    end
  end
end
