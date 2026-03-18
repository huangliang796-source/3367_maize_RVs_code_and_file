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
	my $name=$arr[0];
	my $class=$arr[1];
	$hash{$name}=$class;		
}

my %num;
while(<F>){
	chomp;
	my @arr=split;
	if(!exists $hash{$arr[2]} || !exists $hash{$arr[3]} ){
		next;
	}
	my $id1=$hash{$arr[2]};
	my $id2=$hash{$arr[3]};
	my $pair;
	if($id1 == $id2){
		$pair="$id1-$id2";
	}
	if($id1 > $id2){
		$pair="$id2-$id1";
	}
	if($id1 < $id2){
		$pair="$id1-$id2";
	}
	$num{$pair}++; 
}


foreach my $key(keys %num){
	my @arr=split /-/,$key;
	my $seq=join "\t",@arr;
	print $seq,"\t",$num{$key}	,"\n";
}
