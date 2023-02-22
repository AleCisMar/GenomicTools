#!/bin/bash
usage () { 
echo  usage: bash change_names.sh old.txt new.txt file.fasta
echo old.txt is the list of ids in file.fasta. new.txt is a list of the new names
}

if [[ $# -eq 0 ]] ; then
        echo "ERROR: no arguments provided"
    usage
    exit 0
fi

old="$1"
new="$2"
file="$3"

while IFS= read -r line1 && IFS= read -r line2 <&3; do
  gsed -i "s/$line1/$line2/g" $3
done < "$old" 3< "$new"

