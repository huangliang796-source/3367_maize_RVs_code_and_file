#!/usr/bin/perl
use strict;
use warnings;

my($file)=@ARGV;

open F,"zcat $file|" or die;

my @name;
while(<F>){
	chomp;
	my @arr=split;
	if(/^##/){
		next;
	}
	if(/^#CHROM/){
		for(my $i=9;$i<@arr;$i++){
			$name[$i]=$arr[$i];
		}
	}
	else{
		my $ref=0;
		my $alt=0;
		my $miss=0;
		my $info;
		for(my $i=9;$i<@arr;$i++){
			if($arr[$i] eq "0/0"){
				$ref++;
			}
			elsif($arr[$i] eq "1/1"){
				$alt++;
				$info.="\t$name[$i]";
			}
			elsif($arr[$i] eq "0/1"){
			}
			elsif($arr[$i] eq "./."){
			}
			else{
			}
		}
		if($alt==2){
			print "$arr[0]\t$arr[1]$info\n";
		}
	}
}
		
