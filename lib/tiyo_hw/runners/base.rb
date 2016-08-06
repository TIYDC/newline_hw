module TiyoHw
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

      def file?(*args)
        File.exist?(File.expand_path(File.join(pwd, *args)))
      end

      def prepare_commands
        raise NotImplementedError, "Subclases of Tiyo::Runners::Base must implement prepare_commands"
      end

      def self.get_commands(pwd)
        self.new(pwd).commands
      end
    end
  end
end
