require "fileutils"
require "uri"
require "shellwords"

module NewlineHw
  module Shell
    ##
    # Generate a series of language **AGNOISIC** commands to download and
    # organize a students homework.
    class Setup
      BRANCH_NAME = "submitted_assignment".freeze
      attr_accessor :url, :newline_submission_id, :config
      def initialize(id_or_url, config)
        @config = config
        @newline_submission_id = Integer(id_or_url)
        @url = submission_info["url"]
      rescue ArgumentError
        @config = config
        @url = id_or_url
      end

      def submission_info
        @_submission_info ||= query_submission_info
      end

      def cloneable?
        pr? || gist? || github_project_link? || git? || false
      end

      def sha
        return submission_info["sha"] if @newline_submission_id
        matches = /\b[0-9a-f]{40}\b/.match(url)
        matches.to_s if matches && !gist?
      end

      def git_url
        return infer_git_url_from_pr if pr?
        final_url = url.split("/tree/").first
        "#{final_url}#{'.git' unless final_url.end_with?('.git')}"
      end

      def github_project_link?
        url.starts_with?("https://github.com") && URI(url).path.split("/").reject{|l| l.empty?}.size == 2
      end

      def git?
        url.starts_with?("git") || url.ends_with?(".git")
      end

      def gist?
        /gist\.github\.com/.match(url)
      end

      def pr?
        %r{\/\/github.com}.match(url) && %r{\/pull\/\d+}.match(url)
      end

      def dir_name
        git_url.split(%r{[\/\.]})[-3..-2].join("-")
      end

      def clean_dir
        FileUtils.rm_rf(File.join(homework_path, dir_name))
      end

      def homework_path
        File.expand_path(config.homework_dir)
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
        cmds << fetch_and_checkout_pr if pr?
        cmds << "git checkout #{sha} -b #{BRANCH_NAME}" if sha
        cmds << "echo #{Shellwords.escape JSON.pretty_generate submission_info} > .newline_submission_meta.json" if newline_submission_id
        cmds.join(" && ")
      end

      private def fetch_and_checkout_pr
        "git fetch origin pull/#{pr_id}/head:#{BRANCH_NAME} && git checkout #{BRANCH_NAME}"
      end

      private def infer_git_url_from_pr
        url.split("/pull/").first + ".git"
      end

      private def pr_id
        url.split("/pull/").last.to_i
      end

      private def query_submission_info
        NewlineCli::Api.new.get("assignment_submissions/#{@newline_submission_id}")
      end
    end
  end
end
