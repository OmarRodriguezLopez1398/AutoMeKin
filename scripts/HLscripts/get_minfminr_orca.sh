#!/bin/bash
sharedir=${AMK}/share
source utils.sh
tmp_files=(tmp*)
trap 'err_report $LINENO' ERR
trap cleanup2 EXIT INT

exe=$(basename $0)
cwd=$PWD
inputfile=amk.dat
read_input

i=$1
get_geom_irc

calc=min_irc
level=hl

# Forward minimum
chkfile=minf_$i
geo="$geof"
orca_input
echo -e "insert or ignore into gaussian values (NULL,'minf_$i','$inp_hl');\n.quit" | sqlite3 ${tsdirhl}/IRC/inputs.db

# Reverse minimum
chkfile=minr_$i
geo="$geor"
orca_input
echo -e "insert or ignore into gaussian values (NULL,'minr_$i','$inp_hl');\n.quit" | sqlite3 ${tsdirhl}/IRC/inputs.db