#!/bin/bash
usage () { 
echo  usage: bash split_multi_fasta.sh multi_fasta.fasta
}

if [[ $# -eq 0 ]] ; then
        echo "ERROR: no arguments provided"
    usage
    exit 0
fi

#awk -F '>' '/^>/ {F=sprintf("%s.fasta", $2); print > F;next;} {print >> F; close(F)}' < $1

grep '>' $1 | cut -d'>' -f2 | while read line; do 
	grep -A1 "$line" $1 > "$line".fasta
done
