#!/Users/coco/opt/miniconda2/envs/mypython3.9/bin/python3.9
from Bio import SeqIO
import sys
import argparse

parser = argparse.ArgumentParser(description='A script to extract GenBank genomic DNA into fasta')
parser.add_argument('GenBank_file', help='GenBank file from which to extract genomica DNA sequence')
args = parser.parse_args()

file = sys.argv[1]
inp = open(file)
out = "".join(file.split('.')[:-1]) + '.fasta'

SeqIO.convert(inp, "genbank", out, "fasta")
