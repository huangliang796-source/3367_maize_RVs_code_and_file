#!/usr/bin/perl
use strict;
use warnings;

my($prefix,$num)=@ARGV;

for(my $i=1;$i<=$num;$i++){
	my $file="$prefix/class$i";
	#print $file,"\n";
	open F,$file or die;

	while(<F>){
		chomp;
		my @arr=split;
		print $arr[1],"\t",$i,"\n";
	}
}
