#!/home/cisnerazerx/miniconda3/envs/genomic/bin/python3.12

from Bio import SeqIO

import argparse



def main():

    parser = argparse.ArgumentParser(description='Splits multigenbank file into individual genbank files')

    parser.add_argument('input', type=str, help='Input file')



    args = parser.parse_args()



    with open(args.input, 'r') as input_file:

        records = list(SeqIO.parse(input_file, 'genbank'))        

        for record in records:

            SeqIO.write(record, f'{record.id}.gbk', 'genbank')



if __name__ == '__main__':

    main()

