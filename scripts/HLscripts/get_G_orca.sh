#!/bin/bash
# Final Gibbs free energy in Hartree from ORCA output - takes LAST instance
awk '/G-E\(el\)/{g=$(NF-3)} END{print g}' $1