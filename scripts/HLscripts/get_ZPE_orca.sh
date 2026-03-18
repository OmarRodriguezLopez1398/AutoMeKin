#!/bin/bash
# ZPE en kcal/mol (igual que Gaussian)
awk '/Zero point energy/{printf "%14.9f\n",$NF*627.5095}' $1