#!/usr/bin/perl -w
use strict;
use warnings;

my($file,$ref,$ref2)=@ARGV;
open F,$file or die;
open R,$ref or die;
open R2,$ref2 or die;

my %hash;
while(<R>){
	chomp;
	if(/MAF/){
		next;
	}
	my @arr=split;
	$hash{$arr[1]}=$arr[-1]/3367/2;
	
}close R;


my @id;
my $i=0;
while(<R2>){
	chomp;
	my @arr=split;
	if(/#/){
		next;
	}
	$i++;
	$id[$i]=$arr[2];
}


while(<F>){
	chomp;
	my @arr=split;
	if(/R/){
		next;
	}
	else{
		my $num=$arr[0];
		print $_,"\t",$id[$num],"\t",$hash{$id[$num]},"\n";
	}
}

