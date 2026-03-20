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
orca_input
# orca_input handles sqlite insert internally for min_irc