#!/bin/bash
usage () {
	echo
	echo "Before start make sure you have prodigal, hmmer, fasta_to_gb.py, change_names.sh and genbank_to_protein.py installed"
	echo "If you have circular genomes it is adviced to use solve_circular_genomes.sh to correctly annotate the genomes"
	echo "USAGE: within the working directory containing all the DNA.fasta files type annotate_genomes.sh"
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

echo "##################################################"
echo "Converting DNA fasta files to GenBank format..."
echo "##################################################"
for i in $(ls *.fasta); do 
	fasta_to_gb.py $i
done
echo "Removing uneeded lines from .gb files..."
for i in $(ls *.gb); do 
	gsed -i '$!N;/\n.*FEATURES/!P;D' $i
done
for i in $(ls *.gb); do 
	gsed -i '/FEATURES/d' $i
done
echo "Changing .gb file names to _DNA.gb..."
for i in $(ls *.gb); do 
	mv $i "${i%.gb}_DNA.gb"
done
echo
echo "##################################################"
echo "Running prodigal..."
echo "##################################################"
for i in $(ls *.fasta); do 
	prodigal -i $i -p meta -a "${i%fasta}faa" -o "${i%.fasta}_CDS.gbk"
done
echo
echo "##################################################"
echo "Running hmmscan..."
echo "##################################################"
for i in $(ls *.faa); do 
	hmmscan -E 1e-05 --noali --tblout "${i%faa}tbl" /Volumes/TOSHIBA\ EXT/db/Pfam-A.hmm $i
done
echo
echo "##################################################"
echo "Adding features to GenBank file..."
echo "##################################################"
echo "Creating backup files for _CDS.gbk files..."
for i in $(ls *.gbk); do 
	cp $i "$i".bak
done
echo "Removing uneeded lines from _CDS.gbk.bak files..."
for i in $(ls *.bak); do 
	gsed -i '1d' $i
done
for i in $(ls *.bak); do 
	gsed -i '$d' $i
done
echo "Changing DEFINITION from _DNA.gb files. Using _CDS.gbk DEFINITION..."
for i in $(ls *.gb); do
	grep 'DEFINITION' $i > "${i%gb}old.bak" 
done
for i in $(ls *.gbk); do
	grep 'DEFINITION' $i > "${i%gbk}new.bak"
done
for i in $(ls *.gb); do
	change_names.sh "${i%gb}old.bak" "${i%DNA.gb}CDS.new.bak" $i
done
echo "Merging _CDS.gbk.bak with _DNA.gb. Creating _merged.genbank files..."
for i in $(ls *.gb); do
	gsed "/ORGANISM/r "${i%DNA.gb}CDS.gbk.bak"" $i > "${i%DNA.gb}merged.genbank"
done
rm *.bak
echo "Creating note ID lists..."
for i in $(ls *.genbank); do
	grep note $i | cut -d';' -f1 | cut -d'"' -f2 > "${i%_merged.genbank}.ids.tmp"
done
echo "Creating oneline protein fasta file to obtain sequence lists.."
for i in $(ls *.faa); do 
	awk '/^>/ { if(NR>1) print "";  printf("%s\n",$0); next; } { printf("%s",$0);}  END {printf("\n");}' < $i > "$i".tmp; grep -v '>' "$i".tmp > "${i%faa}seqs.tmp"
done
rm *.gb *.gbk
echo "Adding translations to _merged.genbank files..."
for i in $(ls *.genbank); do 
	paste -d, "${i%_merged.genbank}.ids.tmp" "${i%_merged.genbank}.seqs.tmp" | while IFS=, read a b; do 
		gsed -i "/$a\b/a \/translation=\"$b\"" $i
	done
done 
for i in $(ls *.genbank); do 
	gsed -i 's/\/translation/                     \/translation/g' $i
done
echo "Creating protein_id feature lists..."
for i in $(ls *.faa); do
	grep '>' $i | cut -d' ' -f1 | cut -d'>' -f2 > "${i%faa}prot.ids.tmp"
done
echo "Adding protein_id to _merged.genbank files..."
for i in $(ls *.genbank); do
	paste -d, "${i%_merged.genbank}.ids.tmp" "${i%_merged.genbank}.prot.ids.tmp" | while IFS=, read a b; do
		gsed -i "/$a\b/a \/protein_id=\"$b\"" $i
	done
done 
for i in $(ls *.genbank); do
	gsed -i 's/\/protein_id/                     \/protein_id/g' $i
done
echo "Creating hmmscan annotation lists..."
for i in $(ls *.tbl); do
	awk '!x[$3]++' $i > "${i%.tbl}.best.tbl"
done
for i in $(ls *.best.tbl); do
	grep -v '#' $i | awk -F' ' '{print $1"\t"$3}' > "${i%best.tbl}annotations.tmp"
done
for i in $(ls *.annotations.tmp); do
	cat "${i%annotations.tmp}prot.ids.tmp" | while read line; do
		if [[ $(awk -v awkvar="$line" -F'\t' '{if ($2==awkvar) {print awkvar","$1}}' $i) ]]; then
			awk -v awkvar="$line" -F'\t' '{if ($2==awkvar) {print awkvar","$1}}' $i
		else
			echo $line,hypothetical protein
		fi	
	done > "${i%annotations.tmp}ant.list.tmp"
done
echo "Adding product feature to _merged.genbank files..."
for i in $(ls *.genbank); do
	cat "${i%_merged.genbank}.ant.list.tmp" | while IFS=, read a b; do
		gsed -i "/$a\b/i \/product=\"$b\"" $i
	done
done 
for i in $(ls *.genbank); do
	gsed -i 's/\/product/                     \/product/g' $i
done
rm *.tmp *.tbl
for i in $(ls *.genbank); do 
	mv $i "${i%_merged.genbank}.gbk"
done

rm *.faa
for i in $(ls *.gbk); do 
	genbank_to_protein.py $i
done

echo "DONE"
