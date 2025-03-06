#!/usr/bin/env python

import argparse
import os

def main():
    parser = argparse.ArgumentParser(description='Splits multi-GFF file into individual GFF files')
    parser.add_argument('-i', '--input', type=str, required=True, help='Input multi-GFF file')
    parser.add_argument('-o', '--output_dir', type=str, default='.', help='Output directory for individual GFF files (default: current directory)')
    args = parser.parse_args()

    if not os.path.exists(args.output_dir):
        os.makedirs(args.output_dir)

    genome_ids = []

    with open(args.input, 'r') as input_file:
        for line in input_file:
            if line.startswith('##sequence-region'):
                genome_id = line.split()[1]
                genome_ids.append(genome_id)

    for genome_id in genome_ids:
        output_path = os.path.join(args.output_dir, f'{genome_id}.gff')
        with open(output_path, 'w') as output_file:
            with open(args.input, 'r') as input_file:
                in_fasta_section = False  # Track if we are in the relevant FASTA section

                for line in input_file:
                    if line.startswith('##sequence-region') and genome_id in line:
                        output_file.write(line)  # Write the sequence region line
                    elif line.startswith(genome_id):  
                        output_file.write(line)  # Write the feature line
                    elif line.startswith('>'):
                        if genome_id in line:
                            output_file.write('##FASTA\n')  # Start FASTA section
                            output_file.write(line)  # Write the actual FASTA header
                            in_fasta_section = True  # Start capturing FASTA sequence
                        else:
                            in_fasta_section = False  # Stop when a new genome starts
                    elif in_fasta_section:
                        output_file.write(line)  # Write the FASTA sequence
if __name__ == '__main__':
    main()
