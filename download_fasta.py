#!/Users/coco/opt/miniconda2/envs/mypython3.9/bin/python3.9

from Bio import Entrez
import sys
import argparse

parser = argparse.ArgumentParser(description='A script to download fasta records from a list')
parser.add_argument('id_list', help='A text file containing the list of IDs')
parser.add_argument('out_file', help='Output fasta.fa file name')
parser.add_argument('e_mail', help='Your E-mail address')
parser.add_argument('batch_size', help='Batch size', type=int)
args = parser.parse_args()

#Usage: python DownloadFastaFiles.py id_list.txt output_file_name.gb your@e.mail.com batch_size[integer]

OpenIDlist = open(sys.argv[1])
ReadIDlist = OpenIDlist.read()
SeqIDLists = ", ".join(ReadIDlist.split("\n"))
#print("List of IDs to download is: ")
#print(ReadIDlist)

GenomeSeqFile = sys.argv[2]

Entrez.email = sys.argv[3]
print("The introduced E-mail is: " + Entrez.email)

batchsize = int(sys.argv[4])
n_ids = sum(1 for line in open(sys.argv[1]))
print("Fetching fasta records...")
for start in range (0, n_ids, batchsize):
	handle = Entrez.efetch(db = "nucleotide", id=SeqIDLists, rettype="fasta", retmode="text", retstart=start, retmax=batchsize)
	print('Starting at {} Fetching {} records'.format(start, batchsize))
	print("Writing fasta records to: " + GenomeSeqFile)
	with open(GenomeSeqFile, "a") as GenomeSeqFile_handle:
		GenomeSeqFile_handle.write(handle.read())
	handle.close()
