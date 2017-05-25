require 'pry'
require "fileutils"
require "uri"
require "shellwords"

module NewlineHw
  module Shell
    class SetupAssignment
      attr_reader :assignment_id, :config
      def initialize(assignment_id, config = {})
        @assignment_id = assignment_id
        @config = config
      end

      def assignment
        most_recent_submissions.first['assignment']
      end

      def most_recent_submissions
        query_assignment_submissions['data'].group_by {|s|s['student']['id']}
        .map do |user_id, submissions|
          submissions.max_by {|s| s['created_at']}
        end
      end

      def assignment_title
        assignment['title'].downcase.underscore.strip.gsub(" ", "_")
      end

      def cmd
        config.update({"homework_dir" => "#{config.homework_dir}/#{assignment_title}"})
        FileUtils.mkdir_p(config.homework_dir)

        setup_cmds = most_recent_submissions.map do |submission|
          Shell::Setup.new(submission['id'], config).cmd
        end
        setup_cmds << "cd .."
        setup_cmds.join(" && ")
      end

      private def query_assignment_submissions
        @_query_assignment_submissions ||= \
          NewlineCli::Api.new.get \
            "assignment_submissions?assignment_id=#{assignment_id}"
      end
    end
  end
end
