function hw() {
  URL=$1
  OUTPUT="$(~/code/tiyo-hw/bin/hw setup $URL)"
  eval ${OUTPUT}
  OUTPUT="$(~/code/tiyo-hw/bin/hw run $PWD)"
  eval ${OUTPUT}
}
