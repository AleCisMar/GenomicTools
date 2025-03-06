#!/usr/bin/env python

import argparse
import os

def main():
    parser = argparse.ArgumentParser(description='Splits multi-table file into individual table files')
    parser.add_argument('-i', '--input', type=str, required=True, help='Input multi-table file')
    parser.add_argument('-o', '--output_dir', type=str, default='.', help='Output directory for individual table files (default: current directory)')
    args = parser.parse_args()

    if not os.path.exists(args.output_dir):
        os.makedirs(args.output_dir)

    genome_ids = []

    with open(args.input, 'r') as input_file:
        for line in input_file:
            if line.startswith('>'):
                genome_id = line.strip().split(' ')[1]
                genome_ids.append(genome_id)

    for genome_id in genome_ids:
        output_path = os.path.join(args.output_dir, f'{genome_id}.tbl')
        with open(output_path, 'w') as output_file:
            with open(args.input, 'r') as input_file:
                in_fasta_section = False

                for line in input_file:
                    if line.startswith('>'):
                        if genome_id in line:
                            output_file.write(line)
                            in_fasta_section = True
                        else:
                            in_fasta_section = False
                    elif in_fasta_section:
                        output_file.write(line)

if __name__ == '__main__':
    main()