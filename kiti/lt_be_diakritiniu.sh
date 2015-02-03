# !/bin/bash

sed -re "s/ą/a/g" -e "s/Ą/A/g" -e "s/č/c/g" -e "s/Č/C/g" -e "s/[ęė]/e/g" -e "s/[ĘĖ]/E/g" -e "s/į/i/g" -e "s/Į/I/g" -e "s/š/s/g" -e "s/Š/S/g" -e "s/[ųū]/u/g" -e "s/[ŪŲ]/U/g" -e "s/Ž/Z/g" -e "s/ž/z/g" -e "s/„//g" -e "s/“//g" -e "s/–/-/g" "$1" 
