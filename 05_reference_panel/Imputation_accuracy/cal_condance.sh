#!/bin/bash

range=$1

perl treat_raw.pl raw_$range\.vcf.gz > $range\_raw
perl treat_phased.pl phased_$range\.vcf.gz > $range\_phased
/bin/bash row_correlation.sh $range\_raw $range\_phased $range\_result

zcat raw_$range\.vcf.gz |perl add_miss_rate.pl  $range\_result ~/HuangL/3367/raw_data/genotype/SNP_INDEL_SV.frq -  > $range\_result_treated

