#!/bin/bash
file=$1
# Última ocurrencia de la energía CCSD(T) final
awk '/FINAL SINGLE POINT ENERGY/{e=$NF} END{printf "%14.9f\n",e}' $file