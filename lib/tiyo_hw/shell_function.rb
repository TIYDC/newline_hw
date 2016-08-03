# function hw() {
#   URL=$1
#   OUTPUT="$(~/code/tiyo-hw/bin/hw setup $URL)"
#   eval ${OUTPUT}
#   OUTPUT="$(~/code/tiyo-hw/bin/hw run $PWD)"
#   eval ${OUTPUT}
# }

module TiyoHw
  class ShellFunction
    def self.cmd
      path = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "exe", "tiyohw"))
<<-eos
function hw() {
 URL=$1
 OUTPUT="$(#{path} setup $URL)"
 eval ${OUTPUT}
 OUTPUT="$(#{path} run $PWD)"
 eval ${OUTPUT}
}
eos
    end
  end
end
