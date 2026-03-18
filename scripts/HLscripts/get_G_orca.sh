#!/bin/bash
# Corrección térmica a G en Hartree
awk '/Total enthalpy/{H=$NF}
     /Final Gibbs free energy/{G=$NF}
     END{printf "%14.9f\n",G}' $1