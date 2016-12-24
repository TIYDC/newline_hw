require "fileutils"
require "uri"
require 'shellwords'
module NewlineHw
  class Setup
    attr_accessor :url, :newline_submission_id

    def initialize(opts)
      @newline_submission_id = Integer(opts)
      @url = submission_info["url"]
    rescue
      @url = opts
    end

    def submission_info
      @_submission_info ||= get_submission_info
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
      cmds << "#{EDITOR} ."
      cmds.join(" && ")
    end

    private def get_submission_info
      NewlineCli::Api.new.get("assignment_submissions/#{@newline_submission_id}")
    end
  end
end
