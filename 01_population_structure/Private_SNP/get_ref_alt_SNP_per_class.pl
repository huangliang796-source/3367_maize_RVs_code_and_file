#!/usr/bin/perl
use strict;
use warnings;

my($file,$ref)=@ARGV;
open F,"zcat $file|" or die;
open R,$ref or die;

my %sample;
my @type;

while(<R>){
	chomp;
	my @arr=split;
	$sample{$arr[0]}=$arr[1];
}

while(<F>){
	chomp;
	my @arr=split;
	if(/^##/){
		next;
	}
	if(/^#CHROM/){
		for(my $i=0;$i<@arr;$i++){
			if(exists $sample{$arr[$i]}){
				$type[$i]=$sample{$arr[$i]};
			}
			else{
			#	$type[$i]=0;
			}
		}
	}
	else{
		my @ref=(0) x 20;
		my @alt=(0) x 20;
		my @num=(0) x 20;
		my $id="$arr[0]-$arr[1]";
		for(my $i=9;$i<@arr;$i++){
			
			unless(exists $type[$i]){
				next;
			}
			$num[$type[$i]]++;
			if($arr[$i] eq "0/0"){
				$ref[$type[$i]]++;
			}
			elsif($arr[$i] eq "1/1"){
				$alt[$type[$i]]++;
			}
			elsif($arr[$i] eq "0/1"){		
			}
			elsif($arr[$i] eq "./."){
			}
			else{
				die;
			}
		}
		my $seq="$id";
		for(my $i=1;$i<@num;$i++){
			$seq.="\t$ref[$i]\t$alt[$i]\t$num[$i]";
		}
		$seq.="\n";
		print $seq;
	}
}
		
			


				
