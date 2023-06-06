#USAGE: create a list.txt of .gbk files
# for i in $(cat list.txt ); do echo ">Feature ""${i%.gbk}"; genbank2five-column.sh $i; echo; done

grep -E 'CDS|product' $1 |
sed '/translation/d' |
sed 's/  *//g' |
sed 's/CDS//' |
sed 's/\.\./	/' |
awk '{ if ($1 ~ /complement/) {t=$1; $1=$2; $2=t; print} else {print}}' |
sed 's/  */	/' |
sed 's/calpro/cal pro/' |
sed 's/="/	/' |
tr -d '"' |
tr -d '>' |
tr -d '<' |
gsed '1~2 s/$/	CDS/g' |
sed 's/complement//' |
tr -d ')' |
tr -d '(' |
sed 's/\//			/'
