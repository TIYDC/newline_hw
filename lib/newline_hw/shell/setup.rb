require "fileutils"
require "uri"
require "shellwords"

module NewlineHw
  module Shell
      ##
      # Generate a series of language **AGNOISIC** commands to download and
      # organize a students homework.
    class Setup
      attr_accessor :url, :newline_submission_id, :options
      def initialize(id_or_url, options)
        @newline_submission_id = Integer(id_or_url)
        @options = options
        @url = submission_info["url"]
      rescue ArgumentError
        @options = options
        @url = id_or_url
      end

      def submission_info
        @_submission_info ||= query_submission_info
      end

      def sha
        matches = /\b[0-9a-f]{40}\b/.match(url)
        matches.to_s if matches && !gist?
      end

      def git_url
        final_url = url.split("/tree/").first
        "#{final_url}#{'.git' unless final_url.end_with?('.git')}"
      end

      def gist?
        /gist\.github\.com/.match(url)
      end

      def dir_name
        git_url.split(%r{[\/\.]})[-3..-2].join("-")
      end

      def clean_dir
        FileUtils.rm_rf(File.join(homework_path, dir_name))
      end

      def homework_path
        File.expand_path(HOMEWORK_DIR)
      end

      def setup
        FileUtils.mkdir_p homework_path
      end

      def cmd
        setup
        clean_dir
        cmds = []
        cmds << "cd #{homework_path}"
        cmds << "git clone #{git_url} #{dir_name}"
        cmds << "cd #{dir_name}"
        cmds << "git checkout #{sha} -b submitted_assignment" if sha
        cmds << "echo #{Shellwords.escape JSON.pretty_generate submission_info} > .newline_submission_meta.json" if newline_submission_id
        cmds.join(" && ")
      end

      private def query_submission_info
        NewlineCli::Api.new.get("assignment_submissions/#{@newline_submission_id}")
      rescue Excon::Error::Socket => e
        puts "Error could not open a connection to newline #{e.message}"
        exit 3
      rescue Excon::Error::Forbidden => e
        puts "You do not have access to this submission #{e.message}"
        exit 3
      end
    end
  end
end
