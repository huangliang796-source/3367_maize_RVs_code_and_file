#!/usr/bin/perl
use strict;
use warnings;

my($file1)=@ARGV;

open F1,"zcat $file1 |" or die;

my @name;

my %hash;
while(<F1>){
	chomp;
	my @arr=split;
	if(/^##/){
		next;
	}
	elsif(/^#CHROM/){
		@name=@arr;
	}
	else{
		my $id="$arr[0]\t$arr[1]";
		my $type;
		if(/IMP/){
			$type="IMP";
		}
		else{
			$type="NA";
		}
		for(my $i=9;$i<@arr;$i++){
			my @temp=split /:/,$arr[$i];
			my $base=$temp[1];
			if($type eq "NA"){
				$base="NA";
			}
			if($i==@arr-1){
				print "$base\n";
			}
			else{
				print "$base\t";
			}
	
		}
	}
}


