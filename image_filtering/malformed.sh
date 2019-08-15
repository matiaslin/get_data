#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# This program calls malformed.py and redirects its output to a file named  #
# "malformed.txt".                                                          #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

FILES=$1/*

for file in $FILES
do
  #echo $file
  python $1/malformed.py $file >> $1/malformed.txt
done

echo Done!
