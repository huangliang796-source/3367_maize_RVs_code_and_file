#!/usr/bin/perl
use strict;
use warnings;

my($file,$ref1,$limit,$file_out)=@ARGV;

open F ,$file or die;
open R1,$ref1 or die;

open O,">",$file_out or die;

my $i=0;
my %name;
while(<R1>){
	chomp;
	$i++;
	my @arr=split;
	my $name=$arr[1];
	$name{$i}=$name;
}

$i=0;
while(<F>){
	chomp;
	$i++;
	my @arr=split /\t+/;
	for(my $k=0;$k<@arr;$k++){
		my $j=$k+1;
		if($j<=$i){
			next;
		}
		if($arr[$k]<$limit){
			print O $name{$j},"\t",$name{$i},"\t",$arr[$k],"\n";
		}

	}
}

