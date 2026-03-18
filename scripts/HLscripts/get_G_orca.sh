#!/bin/bash
# Final Gibbs free energy in Hartree from ORCA output
# Line format: "Final Gibbs free energy         ...   -186.14961271 Eh"
awk '/Final Gibbs free energy/{print $(NF-1)}' $1