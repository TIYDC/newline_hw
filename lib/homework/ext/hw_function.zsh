function hw() {
  URL=$1
  OUTPUT="$(~/code/homework/bin/hw setup $URL)"
  eval ${OUTPUT}
  OUTPUT="$(~/code/homework/bin/hw run $PWD)"
  eval ${OUTPUT}
}
