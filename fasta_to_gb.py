#!/Users/coco/opt/miniconda2/envs/mypython3.9/bin/python3.9
from Bio import SeqIO
import sys
import argparse

parser = argparse.ArgumentParser(description='A script to transform fasta DNA into GenBank')
parser.add_argument('fasta_file', help='DNA fasta file to be written in GenBank format')
args = parser.parse_args()

file = sys.argv[1]
inp = open(file)
out = "".join(file.split('.')[:-1]) + '.gb'

SeqIO.convert(inp, "fasta", out, "genbank", "DNA")