#!/usr/bin/perl
use strict;
use warnings;

my($file,$file_out )=@ARGV;

open F,$file or die;
open O,">",$file_out or die;

print O "line\tenv\tvalue\n";

my $env=1;
while(<F>){
	chomp;
	my @arr=split;
	my $combine="$arr[0]\tENV$env\t$arr[$env]";
	print O $combine,"\n";
}

close F;

open F,$file or die;
$env=2;
while(<F>){
	chomp;
	my @arr=split;
	my $combine="$arr[0]\tENV$env\t$arr[$env]";
	print O $combine,"\n";
}

