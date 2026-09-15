#!/usr/bin/perl
use strict;
use warnings;

my($file,$ref)=@ARGV;

open F,$file or die;
open R,$ref or die;

my %hash;
while(<R>){
	chomp;
	my @arr=split;
	if(@arr>1){
		$hash{$arr[0]}=$arr[1];
	}
	else{
		die;
		$hash{$arr[0]}=1;
	}
}

while(<F>){
	chomp;
	my @arr=split;
	if(exists $hash{$arr[1]}){
		print $_," $hash{$arr[1]}\n";
	
	}
	else{
		die;
	}
}
