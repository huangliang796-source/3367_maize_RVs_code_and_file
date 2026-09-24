#!/usr/bin/perl
use strict;
use warnings;

my($file)=@ARGV;

open F,$file or die;

while(<F>){
	chomp;
	my @arr=split;
	if($arr[7]=~/-1/){
		next;
	}
	my $gene_id=$arr[3];
	$gene_id=~s/gene://g;
	my $SNP=$arr[9];
	print $gene_id,"\t",$SNP,"\n";
}

