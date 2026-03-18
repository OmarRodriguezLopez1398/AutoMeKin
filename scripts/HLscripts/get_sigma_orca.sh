#!/bin/bash
# Extrae el número de simetría (sigma) del output de ORCA
# ORCA lo imprime como "Symmetry Number: N" en el bloque termodinámico
sigma=$(awk '/Symmetry Number/{print $NF;exit}' $1)
# Si no aparece (molécula sin simetría o cálculo sin freq) asumir sigma=1
if [ -z "$sigma" ]; then sigma=1; fi
echo $sigma