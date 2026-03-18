#!/bin/bash
file=$1
# ORCA imprime la energía MP2 en la línea "MP2 TOTAL ENERGY"
awk '/MP2 TOTAL ENERGY/{e=$NF} END{printf "%14.9f\n",e}' $file