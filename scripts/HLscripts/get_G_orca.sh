#!/bin/bash
# Final Gibbs free energy in Hartree from ORCA output - takes LAST instance
awk '/Final Gibbs free energy/{g=$(NF-1)} END{print g}' $1