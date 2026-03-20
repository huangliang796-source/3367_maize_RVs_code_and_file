#!/usr/bin/perl
use strict;
use warnings;

my($file1)=@ARGV;
open F1,"zcat $file1 |" or die;

while(<F1>){
	chomp;
	my @arr=split;
	if(/^##/){
		next;
	}
	elsif(/^#CHROM/){
	}
	else{
		for(my $i=9;$i<@arr;$i++){
			my @temp=split /;/,$arr[$i];
			my $base;
			if($temp[0]=~/0\|0/ || $temp[0]=~/0\/0/ ){
				$base="0";
			}
			elsif($temp[0]=~/1\|1/ || $temp[0]=~/1\/1/){
				$base="2";
			}	
			elsif($temp[0]=~/0\|1/ || $temp[0]=~/0\/1/){
				$base="1";
			}
			else{
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


