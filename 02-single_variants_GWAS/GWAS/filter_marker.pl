#!/usr/bin/perl -w
use strict;
use warnings;

my($file)=@ARGV;
open F,"zcat $file |" or die;

my %hash;
while(<F>){
	chomp;
	my @arr=split;
	if(/CHR/i)	{
		next;
	}
	if( ( $arr[-1]*$arr[-2]> 20 || $arr[-2]> 0.01) && ( $arr[-1]*(1-$arr[-2]) > 20 || (1-$arr[-2])> 0.01)){
		print $arr[1],"\n";
	}

}close F;

