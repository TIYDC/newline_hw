# function hw() {
#   URL=$1
#   OUTPUT="$(~/code/tiyo-hw/bin/hw setup $URL)"
#   eval ${OUTPUT}
#   OUTPUT="$(~/code/tiyo-hw/bin/hw run $PWD)"
#   eval ${OUTPUT}
# }

module NewlineHw
  module Shell
    class Function
      HW_FUNCTION = "hw".freeze
      def self.cmd
        path = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "exe", "newlinehw"))
        <<-eos
function #{HW_FUNCTION}() {

  if [[ $# -eq 0 ]] ; then
      echo 'WARNING: You must provide a git url, pull-request url or a Newline Submission ID.'
      exit 0
  fi

 URL=$1
 OUTPUT="$(#{path} setup_command $*)"
 eval $OUTPUT
 OUTPUT="$(#{path} run_command $PWD $*)"
 eval $OUTPUT
}
eos
      end
    end
  end
end
