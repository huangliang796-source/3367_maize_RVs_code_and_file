#!/usr/bin/perl -w
use strict;
use warnings;

my($file,$ref1,$ref2,$ref3,$value)=@ARGV;

open F,$file or die;
open R1,$ref1 or die;
open R2,"zcat $ref2 |" or die;
open R3,$ref3 or die;

my %wanted;
while(<R3>){
	chomp;
	my @arr=split;
	$wanted{$arr[0]}=1;
}

my %effect_base;
while(<R1>){
	chomp;
	my @arr=split;
	if(exists $wanted{$arr[0]}){
		$effect_base{$arr[0]}=$arr[1];
	}
}close R1;


my %other_allele;
my %size;
my %AF;
while(<R2>){
	chomp;
	my @arr=split;
	if(/CHR/){
		next;
	}
	my $id=$arr[1];
	if(exists $wanted{$id}){
		my $minor_allele=$arr[2];
		my $size=$arr[-1]/2;
		$size{$id}=$size;
		if($minor_allele eq $effect_base{$id}){
			$other_allele{$id}=$arr[3];
			$AF{$id}=$arr[-2];
		}
		else{
			$other_allele{$id}=$arr[2];
			$AF{$id}=1-$arr[-2];
		}
	}

			
	
}close R2;


print "SNP\tA1\tA2\tfreq\tb\tse\tp\tN\n";
while(<F>){
	chomp;
	my @arr=split;
	my $id=$arr[0];
	if(exists $wanted{$id}){
		my $minor_allele=$effect_base{$id};
		my $other_allele=$other_allele{$id};
		my $AF=$AF{$id};
		my $b=$arr[1];
		my $se=$arr[2];
		my $p=$arr[3];
		my $size=$size{$id};
		if(abs($b) > $value && $p>0.01){
			next;
		}
		$b=0-$b;
		print "$id\t$minor_allele\t$other_allele\t$AF\t$b\t$se\t$p\t$size\n";
	}

}

