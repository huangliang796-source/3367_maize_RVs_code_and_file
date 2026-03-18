#!/usr/bin/perl
use strict;
use warnings;

my($file,$file_out)=@ARGV;
open F,$file or die;
open O,">",$file_out or die;

my %hash_inter_one;
my %hash_inter_two;
my $total;
while(<F>){
	chomp;
	my @arr=split;
	my $chro1=$arr[0];
	my $chro2=$arr[1];
	$total+=$arr[2];
	$hash_inter_one{$chro1}+=$arr[2];	
	$hash_inter_one{$chro2}+=$arr[2];
	$hash_inter_two{"$chro1\t$chro2"}+=$arr[2];
}

for( my $i=1;$i<=19;$i++){
        for(my $j=$i;$j<=19;$j++){
                my $temp1=($hash_inter_one{"$i"}/$total/2)*($hash_inter_one{"$j"}/($total*2-$hash_inter_one{"$i"}));
                my $temp2=($hash_inter_one{"$j"}/$total/2)*($hash_inter_one{"$i"}/($total*2-$hash_inter_one{"$j"}));
                my $expect=($temp1+$temp2)*$total;
                my $observed=$hash_inter_two{"$i\t$j"};
                if($i==$j){
                       print O "$i\t$j\tNA\n"; 
                }
                else{
                        my $ratio=$observed/$expect;;
                	print O  "$i\t$j\t$ratio\n";

		}
        }
        
}

