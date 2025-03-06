#!/usr/bin/env python

from Bio import SeqIO
import argparse
import os
from collections import defaultdict

def main():
    parser = argparse.ArgumentParser(description='Splits multi-FASTA file into individual FASTA files')
    parser.add_argument('-i', '--input', type=str, required=True, help='Input multi-FASTA file')
    parser.add_argument('-t', '--type', choices=['nt', 'aa', 'cds'], required=True, help='Type of sequences in the input file (nucleotide aminoacid or CDS (ffn))')
    parser.add_argument('-o', '--output_dir', type=str, default='.', help='Output directory for individual FASTA files (default: current directory)')
    args = parser.parse_args()

    if not os.path.exists(args.output_dir):
        os.makedirs(args.output_dir)

    if args.type == 'aa':
        extension = '.faa'
        # Group sequences by genome
        genome_sequences = defaultdict(list)
        with open(args.input, 'r') as input_file:
            for record in SeqIO.parse(input_file, 'fasta'):
                genome_id = record.id.split('_CDS')[0]  # Assuming genome ID is the part before '_CDS'
                genome_sequences[genome_id].append(record)

        # Write each group of sequences to a separate file
        for genome_id, sequences in genome_sequences.items():
            output_path = os.path.join(args.output_dir, f'{genome_id}{extension}')
            SeqIO.write(sequences, output_path, 'fasta')
    elif args.type == 'cds':
        extension = '.ffn'
        # Group sequences by genome
        genome_sequences = defaultdict(list)
        with open(args.input, 'r') as input_file:
            for record in SeqIO.parse(input_file, 'fasta'):
                genome_id = record.id.split('_CDS')[0]
                genome_sequences[genome_id].append(record)
                
                # Write each group of sequences to a separate file
        for genome_id, sequences in genome_sequences.items():
            output_path = os.path.join(args.output_dir, f'{genome_id}{extension}')
            SeqIO.write(sequences, output_path, 'fasta')
    else:
        extension = '.fna'
        # Write each sequence to a separate file
        with open(args.input, 'r') as input_file:
            for record in SeqIO.parse(input_file, 'fasta'):
                output_path = os.path.join(args.output_dir, f'{record.id}{extension}')
                SeqIO.write(record, output_path, 'fasta')

if __name__ == '__main__':
    main()