#!/bin/bash
file=$1
# Igual que DFT, ORCA usa la misma línea para HF
awk '/FINAL SINGLE POINT ENERGY/{e=$NF} END{printf "%14.9f\n",e}' $file