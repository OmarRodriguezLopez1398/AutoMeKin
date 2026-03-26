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

/CARTESIAN COORDINATES \(ANGSTROEM\)/{
   getline
   delete sym; delete x; delete y; delete z
   natom=0
   while(1){
      getline
      if(NF==0) break
      natom++
      sym[natom]=$1; x[natom]=$2; y[natom]=$3; z[natom]=$4
   }
}

/NORMAL MODES/{
   for(i=1;i<=5;i++) getline
   delete tmp_nm
   cur_nfreq=0; cur_ncols=0
   in_nm=1
   next
}

in_nm==1{
   if(NF==0) next

   is_header=1
   for(k=1;k<=NF;k++) if($k !~ /^[0-9]+$/) { is_header=0; break }

   if(is_header && NF>=1){
      cur_nfreq+=cur_ncols
      cur_ncols=NF
      for(k=1;k<=cur_ncols;k++) modecol[k]=cur_nfreq+k
      next
   }

   if($1~/^[0-9]+$/ && NF>1){
      row=$1+1
      for(k=1;k<=cur_ncols;k++) tmp_nm[modecol[k],row]=$(k+1)
      next
   }

   in_nm=0
   cur_nfreq+=cur_ncols
   nfreq=cur_nfreq
   delete nm
   for(key in tmp_nm) nm[key]=tmp_nm[key]
}

END{
   if(in_nm==1){
      cur_nfreq+=cur_ncols
      nfreq=cur_nfreq
      delete nm
      for(key in tmp_nm) nm[key]=tmp_nm[key]
   }

   for(i=1;i<=natom;i++)
      print sym[i], atobohr*x[i], atobohr*y[i], atobohr*z[i] >> "'$2'.molden"
   print "" >> "'$2'.molden"
   print "[FR-NORM-COORD]" >> "'$2'.molden"
   for(i=7;i<=nfreq;i++){
      print "Vibration "i-6 >> "'$2'.molden"
      for(j=1;j<=natom;j++)
         print nm[i,3*j-2]*atobohr, nm[i,3*j-1]*atobohr, nm[i,3*j]*atobohr >> "'$2'.molden"
   }
}' $1