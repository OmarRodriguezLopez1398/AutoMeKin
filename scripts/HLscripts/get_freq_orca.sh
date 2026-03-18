#!/bin/bash
# Vibrational frequencies in cm-1 from ORCA output
# Line format: "     6:     720.77 cm**-1"
awk '/VIBRATIONAL FREQUENCIES/{
   getline   # skip "---..." line
   getline   # skip blank line
   getline   # skip "Scaling factor..." line
   getline   # skip blank line
   while(1){
      getline
      if($0 !~ /cm\*\*-1/) break
      freq=$2
      val=freq; if(val<0) val=-val
      if(val<1) freq=1
      printf "%5.0f\n", freq
   }
}' $1