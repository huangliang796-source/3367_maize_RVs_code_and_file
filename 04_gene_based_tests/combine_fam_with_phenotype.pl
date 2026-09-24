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
	my $id=$arr[1];
	if($arr[-1] eq "NA"){
		next;
	}
	$hash{$id}=$arr[-1];
}


while(<F>){
	chomp;
	my @arr=split;
	my $id=$arr[1];
	if(exists $hash{$arr[1]}){
		$arr[5]=$hash{$arr[1]};
	}
	my $seq=join " ",@arr;
	print $seq,"\n";
}

