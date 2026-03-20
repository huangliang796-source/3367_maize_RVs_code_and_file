#!/usr/bin/perl
use strict;
use warnings;

my($file,$tag)=@ARGV;


open F,$file or die;


while(<F>){
	chomp;
	my @arr=split;
	if($arr[-1] eq $tag){
		print $_,"\n";
	}
}
