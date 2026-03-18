#!/bin/bash
# Displaces TS geometry along imaginary normal mode
# Usage: get_NM_orca.sh <ts.log> <sign: 1 or -1>
file=$1
sign=$2

awk -v sign=$sign '
# Get last geometry
/CARTESIAN COORDINATES \(ANGSTROEM\)/{
   getline
   delete sym; delete x; delete y; delete z
   i=1
   while(1){
      getline
      if(NF==0) break
      sym[i]=$1; x[i]=$2; y[i]=$3; z[i]=$4
      natom=i; i++
   }
}
# Get normal mode of imaginary frequency (first non-zero mode)
/NORMAL MODES/{
   # skip headers
   getline; getline; getline; getline; getline
   # read displacement vectors, first column is imaginary mode
   for(k=1;k<=natom*3;k++){
      getline
      dx_flat[k]=$2   # first mode displacement
   }
}
END{
   # Convert flat displacement array to per-atom dx,dy,dz
   for(i=1;i<=natom;i++){
      dx[i]=sign*dx_flat[(i-1)*3+1]
      dy[i]=sign*dx_flat[(i-1)*3+2]
      dz[i]=sign*dx_flat[(i-1)*3+3]
   }
   for(i=1;i<=natom;i++){
      printf "%3s %15.8f %15.8f %15.8f\n", sym[i], x[i]+dx[i], y[i]+dy[i], z[i]+dz[i]
   }
   print ""
}' $file