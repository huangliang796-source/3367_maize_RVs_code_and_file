#!/usr/bin/perl
use strict;
use warnings;
use List::Util;


my($file,$file_out,$total_num,$wanted)=@ARGV;

open F,$file or die;
open O,">",$file_out or die;


my @seq;

for(my $i=0;$i<$total_num;$i++){
	$seq[$i]=$i;
}

@seq = List::Util::shuffle @seq;


my %hash;
for(my $i=0;$i<$wanted;$i++){
	$hash{$seq[$i]}++;
	my $value=$seq[$i]+1;
	#print $value,"\n";
}
my $i=0;

while(<F>){
	chomp;
	if(exists $hash{$i}){
		print O $_,"\n";
	}
	$i++;
}
	

