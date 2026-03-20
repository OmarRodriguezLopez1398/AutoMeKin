#!/bin/bash
# Vibrational frequencies in cm-1 from ORCA output - takes LAST instance
# Skips near-zero frequencies, starts from first non-zero (including imaginary)
awk '/VIBRATIONAL FREQUENCIES/{
   getline; getline; getline; getline   # skip headers and blank lines
   delete freqs
   nfreq=0
   while(1){
      getline
      if($0 !~ /cm\*\*-1/) break
      freq=$2
      val=freq; if(val<0) val=-val
      if(val<1) continue                # skip near-zero freqs (translation/rotation)
      nfreq++
      freqs[nfreq]=freq
   }
}
END{
   for(i=1;i<=nfreq;i++) printf "%5.0f\n", freqs[i]
}' $1