#!/usr/bin/perl
use strict;
use warnings;

# grep product *.gbk | cut -d'=' -f2 | tr -d '"' | sort | uniq > list.txt
# usage: for i in $(ls *.gbk); do perl test.pl list.txt $i > "$i.tmp"; done
# sed -i '1s/^/ \n/' list.txt
# paste list.txt *.tmp > all.txt
# rm *.tmp

my $list = $ARGV[0];
my $gbk = $ARGV[1];

open (LIST, $list) or die "Can't open $list: $!";
print "$gbk\n";
open (GBK, $gbk) or die "Can't open $gbk: $!";

# Create array with list
my @list = <LIST>;
my @product;
my @product_list;

# for every line in gbk file that contains "product=" create an array with the product name
while (<GBK>) {
    if (/product=/) {
        # create array with product name
        @product = split(/=/, $_);
        # remove " from product name
        $product[1] =~ s/"//g;
        # push product name to array
        push @product_list, $product[1];
    }
}

# create counter
my $count = 0;

# loop through list
foreach my $line (@list) {
    # remove new line
    chomp $line;
    # loop through product list
    foreach my $product (@product_list) {
        # if product name is in list, increase counter
        if ($product =~ /^$line$/) {
            $count++;
        }
    }
    # print product name and counter
    print "$count\n";
    # reset counter
    $count = 0;
}
