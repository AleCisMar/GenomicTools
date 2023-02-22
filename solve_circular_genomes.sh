#!/bin/bash
usage () {
	echo
	echo "Before start make sure you have blast, emboss and prodigal installed"
	echo "This script is recommended before attempting circular genomes annotation"
	echo "USAGE: within the working directory containing all the DNA.fasta files type solve_circular_genomes.sh"
	echo
}

echo "** Settings **"
while :; do
	case $1 in
		-h)
			echo "-h help requested"
			echo "Printing help..."
			usage
			exit 1
			;;
		*)
			break
			;;
	esac
done

for i in $(ls *.fasta); do 
	makeblastdb -in $i -dbtype nucl
done


for i in $(ls *.fasta); do 
	blastn -query $i -db $i -outfmt '6 qlen slen length qstart qend sstart send' > "${i%.fasta}"_blast.tmp
	length=$(( $(awk -F'\t' '{if ($7==$1) print $0}' "${i%.fasta}"_blast.tmp | awk -F'\t' '{if ($5=="127") print $0}' | awk '{print $6}') - 1 ))
	sbegin1=$(awk -F'\t' '{if ($7==$1) print $0}' "${i%.fasta}"_blast.tmp | awk -F'\t' '{if ($5=="127") print $0}' | awk '{print $4}')
	sbegin2=$(awk -F'\t' '{if ($7==$1) print $0}' "${i%.fasta}"_blast.tmp | awk -F'\t' '{if ($5=="127") print $0}' | awk '{print $5}')
	send1=$(awk -F'\t' '{if ($7==$1) print $0}' "${i%.fasta}"_blast.tmp | awk -F'\t' '{if ($5=="127") print $0}' | awk '{print $6}')
	send2=$(( $(awk -F'\t' '{if ($7==$1) print $0}' "${i%.fasta}"_blast.tmp | awk -F'\t' '{if ($5=="127") print $0}' | awk '{print $6}') - 1 ))
	seqret -auto -stdout -sequence $i -sbegin1 $sbegin1 -send1 $send1 -outseq "${i%.fasta}"_"$sbegin1"-"$send".tmp
	seqret -auto -stdout -sequence $i -sbegin1 $sbegin2 -send1 $send2 -outseq "${i%.fasta}"_"$sbegin2"-"$send".tmp
	awk '/^>/ { if(NR>1) print "";  printf("%s\n",$0); next; } { printf("%s",$0);}  END {printf("\n");}' < "${i%.fasta}"_"$sbegin1"-"$send".tmp > "${i%.fasta}"_"$sbegin1"-"$send"_oneline.tmp
	awk '/^>/ { if(NR>1) print "";  printf("%s\n",$0); next; } { printf("%s",$0);}  END {printf("\n");}' < "${i%.fasta}"_"$sbegin2"-"$send".tmp > "${i%.fasta}"_"$sbegin2"-"$send"_oneline.tmp
	gsed -i '1d' "${i%.fasta}"_"$sbegin1"-"$send"_oneline.tmp
	gsed -i '1d' "${i%.fasta}"_"$sbegin2"-"$send"_oneline.tmp
	paste "${i%.fasta}"_"$sbegin2"-"$send"_oneline.tmp "${i%.fasta}"_"$sbegin1"-"$send"_oneline.tmp | sed $'s/\t//' > pasted.tmp
	echo ">""${i%.fasta}"_"$sbegin2"-"$send"_"$sbegin1"-"$send" > header.tmp
	cat header.tmp pasted.tmp > "${i%.fasta}"_"$sbegin2"-"$send"_"$sbegin1"-"$send".tmp
	prodigal -a pasted.faa -i "${i%.fasta}"_"$sbegin2"-"$send"_"$sbegin1"-"$send".tmp -o pasted.gbk -p meta
	begin=$(grep '>' pasted.faa | head -n2 | sed '1d' | cut -d'#' -f2 | sed 's/ //')
	end=$(( begin+length-1 ))
	seqret -auto -stdout -sequence "${i%.fasta}"_"$sbegin2"-"$send"_"$sbegin1"-"$send".tmp -sbegin1 $begin -send1 $end -outseq "${i%.fasta}"_corrected.fasta
	rm *.tmp *.faa *.gbk
done

rm *.nhr *.nin *.nsq
