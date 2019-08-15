#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# This program reads each line in the file named "malformed.txt" and removes  #
# the images with their names contained in the text file.                     #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

input="$1/malformed.txt"

while IFS= read -r line
do
  #echo $line
  rm $line
# ls | grep $line
done < "$input"

echo Done!
