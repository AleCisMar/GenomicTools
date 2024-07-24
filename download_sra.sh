# Install https://github.com/ncbi/sra-tools
for i in $(cat SRR_Acc_List.txt); do 
	prefetch $i
	fasterq-dump -O reads $i/$i.sra
	#rm -r $i
done
