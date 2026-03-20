#!/usr/bin/perl -w
use strict;
use warnings;

my($file,$lim)=@ARGV;

open F,$file or die;

my $num;
my $sum;
while(<F>){
	chomp;
	my @arr=split;
	if( /NOT_enough_data/ || /R/ ){
		next;
	}
	if(/NO_true_variant/){
		next;
	}
	if($arr[-1]>$lim ){
		$num++;
		$sum+=$arr[1];
	}
}


my $ave=$sum/$num;
print "$file\t$ave\t$sum\t$num\n";

