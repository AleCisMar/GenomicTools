grep product *.gbk | cut -d'=' -f2 | tr -d '"' | sort | uniq > list.txt
for i in $(ls *.gbk); do perl count_domains.pl list.txt $i > "$i.tmp"; done
sed -i '1s/^/\n/' list.txt
paste list.txt *.tmp > domain_count.tsv
rm *.tmp
