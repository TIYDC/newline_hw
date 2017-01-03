module NewlineHw
  module Shell
    module Runners
      class Base
        attr_reader :commands, :pwd

        def initialize(pwd)
          @commands = []
          @pwd = pwd
          prepare_commands
        end

        def add_command(cmd)
          @commands << cmd
        end

        def file_path(*args)
          File.expand_path(File.join(pwd, *args))
        end

        def file?(*args)
          File.exist?(file_path(*args))
        end

        def file_contents?(regex, *args)
          return false unless file?(*args)
          !File.readlines(file_path(*args)).grep(regex).empty?
        end

        def prepare_commands
          raise NotImplementedError, "Subclases of Tiyo::Runners::Base must implement prepare_commands"
        end

        def self.get_commands(pwd)
          new(pwd).commands
        end
      end
    end
  end
end
