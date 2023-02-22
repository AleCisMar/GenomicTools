#!/bin/bash
usage () { 
echo  usage: bash split_multi_genbank.sh multi_genbank.gb
}

if [[ $# -eq 0 ]] ; then
        echo "ERROR: no arguments provided"
    usage
    exit 0
fi

seqret -auto -stdout -osformat2 Genbank -feature Yes -ossingle2 $1
