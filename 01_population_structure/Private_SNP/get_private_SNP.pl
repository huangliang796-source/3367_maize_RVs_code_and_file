#!/usr/bin/perl
use strict;
use warnings;

my($file)=@ARGV;

open F,$file or die;

while(<F>){
	chomp;
	my @arr=split;
	my $id=$arr[0];
	
	my $miss=0;
	my $total=0;
	my @ratio;
	my $j=0;
	for(my $i=1;$i<@arr;$i=$i+3){
		$j++;
		my $miss_in_group=$arr[$i+2]-$arr[$i]-$arr[$i+1];
		$total+=$arr[$i+2];
		$miss+=$miss_in_group;
		my $frequcy;
		if($arr[$i]+$arr[$i+1]==0){
			#print $_,"\n";
			#print $j,"\t",$arr[$i],"\t",$arr[$i+1],"\n";
			$frequcy=0;
		}
		else{
			$frequcy=$arr[$i+1]/($arr[$i]+$arr[$i+1]); 
		}
		$ratio[$j]=$frequcy;
	}
	
	if($miss/$total>0.5){
	#	next;
	}
		
	my $num=0;
	my $max=0;
	
	my $ID;
	for(my $j=1;$j<@ratio;$j++){
		if($ratio[$j] ==0){
			$num++;
		}
		elsif( $ratio[$j]> $max){
			$max=$ratio[$j]	;
			$ID=$j;
		}
	}
	if($num==18 &&  $max>=0.01){
			print $id,"\t",$ID,"\n";
	}
}

	
