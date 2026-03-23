#!/bin/bash
# Generates a molden file with frequencies and normal modes from ORCA output
# Usage: get_NM_orca_molden.sh <orca.log> <output_prefix>
sharedir=${AMK}/share

echo "[Molden Format]" > $2.molden
echo "[FREQ]"         >> $2.molden
get_freq_orca.sh $1 | awk '{printf "%6.1f\n",$1}' >> $2.molden
echo "       " >> $2.molden
echo "[FR-COORD]" >> $2.molden

awk 'BEGIN{atobohr=1.889726}
# Get last geometry in Angstrom and convert to Bohr
/CARTESIAN COORDINATES \(ANGSTROEM\)/{
   getline   # skip "---..." line
   delete sym; delete x; delete y; delete z
   i=1
   while(1){
      getline
      if(NF==0) break
      sym[i]=$1; x[i]=$2; y[i]=$3; z[i]=$4
      natom=i; i++
   }
}
# Get normal modes - ORCA prints them in blocks of 6
/NORMAL MODES/{
   getline; getline; getline; getline; getline   # skip headers
   nfreq=0
   while(1){
      getline
      if(NF==0) break
      if($1~/[0-9]+:/) {
         # This is a mode index line, read the block
         ncols=NF-1    # number of modes in this block
         for(k=1;k<=ncols;k++) modecol[k]=nfreq+k
         for(at=1;at<=natom*3;at++){
            getline
            for(k=1;k<=ncols;k++) nm[modecol[k],at]=$(k+1)
         }
         nfreq+=ncols
      }
   }
}
END{
   # Print geometry in Bohr
   for(i=1;i<=natom;i++){
      print sym[i], atobohr*x[i], atobohr*y[i], atobohr*z[i] >> "'$2'.molden"
   }
   print "" >> "'$2'.molden"
   print "[FR-NORM-COORD]" >> "'$2'.molden"
   # Print normal modes
   for(i=1;i<=nfreq;i++){
      print "Vibration "i >> "'$2'.molden"
      for(j=1;j<=natom;j++){
         print nm[i,3*j-2]*atobohr, nm[i,3*j-1]*atobohr, nm[i,3*j]*atobohr >> "'$2'.molden"
      }
   }
}' $1
