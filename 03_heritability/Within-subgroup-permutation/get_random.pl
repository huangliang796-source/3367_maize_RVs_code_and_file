#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(shuffle); 


die "Usage: $0 <group_file> <phenotype_file> [random_seed]\n" unless @ARGV >= 2;

my ($group_file, $pheno_file, $seed) = @ARGV;
srand($seed) if defined $seed; 

my %id2group;
open my $gf, '<', $group_file or die ;
while (<$gf>) {
    chomp;
    next if /^\s*$/; 
    my ($id, $group) = split /\t/;
    $id2group{$id} = $group;
}
close $gf;



my @pheno_all;       
my %group_pheno_vals;
my %group_line_idx;  

open my $pf, '<', $pheno_file or die "无法打开 $pheno_file: $!";
my $line_num = 0;
while (<$pf>) {
    chomp;
    next if /^\s*$/;
    my ($fid, $iid, $pheno) = split /\t/;
    push @pheno_all, [$fid, $iid, $pheno];

 
    if (exists $id2group{$iid}) {
        my $g = $id2group{$iid};
        if ($pheno ne 'NA') {
            push @{$group_pheno_vals{$g}}, $pheno;
            push @{$group_line_idx{$g}}, $line_num;
        }
    } else {
        
    }
    $line_num++;
}
close $pf;


foreach my $group (keys %group_pheno_vals) {
    my @vals = @{$group_pheno_vals{$group}};
    my @idxs = @{$group_line_idx{$group}};
    next if scalar @vals != scalar @idxs; 


    my @shuffled = shuffle @vals;

 
    for (my $i = 0; $i < @idxs; $i++) {
        $pheno_all[ $idxs[$i] ][2] = $shuffled[$i];
    }
}


foreach my $row (@pheno_all) {
    print join("\t", @$row), "\n";
}
