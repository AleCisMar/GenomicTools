#!/usr/bin/env python

import argparse

def main():
    parser = argparse.ArgumentParser(description='Search PFAM IDs from input file in PFAM2function file')
    parser.add_argument('-i', '--input', required=True, help='Input file with PFAM IDs in second column. Example domain_info.tsv')
    parser.add_argument('-p', '--pfam2function', required=True, help='PFAM2function file. Example PFAM2function.tsv')
    parser.add_argument('-o', '--output', required=True, help='Output file with PFAM IDs and their functions. Example domain_info_with_function.tsv')
    args = parser.parse_args()

    # Read the PFAM2function file into a list of lists
    with open(args.pfam2function, 'r') as pfam2function_file:
        pfam2function_header = pfam2function_file.readline().strip().split('\t')
        pfam2function_data = [line.strip().split('\t') for line in pfam2function_file]

    # Read the input file and write the output file
    with open(args.input, 'r') as input_file:
        with open(args.output, 'w') as output_file:
            input_header = input_file.readline().strip().split('\t')
            output_file.write('\t'.join(input_header) + '\t' + pfam2function_header[2] + '\n')

            for line in input_file:
                line = line.strip().split('\t')
                if len(line) < 4:
                    line.extend([''] * (4 - len(line)))  # Ensure the line has 4 columns
                pfam_id = line[1]
                found = False
                for pfam2function_line in pfam2function_data:
                    if pfam_id == pfam2function_line[0]:
                        output_file.write('\t'.join(line) + '\t' + pfam2function_line[2] + '\n')
                        found = True
                        break
                if not found:
                    output_file.write('\t'.join(line) + '\tNot found\n')

if __name__ == "__main__":
    main()