#!/usr/bin/perl
use strict;
use warnings;

my($file,$file_out ,$size)=@ARGV;
open F,$file or die;
open O,">",$file_out or die;

while(<F>){
	chomp;
	my @arr=split;
	my $start;
	my $end;
	if($arr[4] eq "+"){
		$start=$arr[1]-$size;
		if($start<=0){
			$start=1;
		}
		$end=$arr[1];
	}
	elsif($arr[4] eq "-"){
		$start=$arr[2];
		$end=$arr[2]+$size;
	}
	else{
		die;
	}
	$arr[-1].=".promoter";
	$arr[1]=$start;
	$arr[2]=$end;
	my $seq=join "\t",@arr;
	print O $seq,"\n";
}
		
	

