#!/usr/bin/perl
use strict;
use warnings;

my($file,$ref)=@ARGV;

open F,"zcat $file|" or die;
open R,$ref or die;

my %hash;
while(<R>){
	chomp;
	my @arr=split;
	my $id="$arr[0]-$arr[1]";
	$hash{$id}=1;
}

while(<F>){
	chomp;
	my @arr=split;	
	if(/#/){
		print $_,"\n";
	}
	else{
		my $id="$arr[0]-$arr[1]";
		if(exists $hash{$id}){
			print $_,"\n";
		}
	}
}
