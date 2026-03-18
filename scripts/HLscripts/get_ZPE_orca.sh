#!/bin/bash
# ZPE in kcal/mol from ORCA output
# Line format: "Zero point energy                ...      0.03711484 Eh      23.29 kcal/mol"
awk '/Zero point energy/{print $(NF-1)}' $1