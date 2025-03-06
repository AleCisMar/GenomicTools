#!/home/cisnerazerx/miniconda3/envs/genomic/bin/python3.12

import argparse

def main():
    parser = argparse.ArgumentParser(description='Process some input file and a string.')
    parser.add_argument('input_file', type=str, help='The input file')
    parser.add_argument('user_string', type=str, help='A string provided by the user')

    args = parser.parse_args()

    # Read the input file and store the modified lines
    modified_lines = []
    with open(args.input_file, 'r') as f:
        for line in f:
            if line.startswith('>'):
                modified_lines.append(line.strip() + args.user_string + '\n')
            else:
                modified_lines.append(line.strip() + '\n')

    # Write the modified lines back to the input file
    with open(args.input_file, 'w') as f:
        f.writelines(modified_lines)

if __name__ == '__main__':
    main()