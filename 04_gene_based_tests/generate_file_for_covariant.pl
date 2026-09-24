#!/usr/bin/perl
use strict;
use warnings;

my($file,$ref,$file_out)=@ARGV;
open F,$file or die;
open R,$ref or die;
open O,">",$file_out or die;

my %hash;
while(<R>){
	chomp;
	my @arr=split;
	my $id=$arr[1];
	$hash{$id}=$arr[0];
}
print O "FID\tIID\tPC1\tPC2\tPC3\tPC4\n";

while(<F>){
	chomp;
	my @arr=split;
	my $id=$arr[1];
	if(exists $hash{$id}){
		print O "$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]\t$arr[5]\t$arr[6]\n";
	}
	else{
		print $id,"\n";
		die;
	}
}

