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
	$hash{$arr[0]}=1;
}


while(<F>){
	chomp;
	my @arr=split;
	if(exists $hash{$arr[0]} || exists $hash{$arr[1]}){
		print $_,"\n";
	}
}

