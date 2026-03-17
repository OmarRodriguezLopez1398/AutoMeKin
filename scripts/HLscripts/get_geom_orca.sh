#!/bin/bash
sharedir=${AMK}/share
elements=${sharedir}/elements

# Extracts the last "CARTESIAN COORDINATES (ANGSTROEM)" block from an ORCA output
awk 'BEGIN{huge=1000000}
{if(NR == FNR) l[NR]=$1}
/CARTESIAN COORDINATES \(ANGSTROEM\)/{
   getline   # skip header line "---..."
   getline   # skip blank line
   i=1
   while(i<=huge){
      getline
      if(NF==0) break
      sym[i]=$1
      x[i]=$2
      y[i]=$3
      z[i]=$4
      natom=i
      i++
   }
}
END{
   i=1
   while(i<=natom){
      print sym[i], x[i], y[i], z[i]
      i++
   }
}' $elements $1