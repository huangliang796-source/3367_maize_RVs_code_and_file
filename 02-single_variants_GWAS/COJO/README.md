# COJO analysis
## step1: calculate the SD of phenotype
```bash
Rscript get_SD.r DTA
```
The standard deviation were calculated for each traits. for example, the SD of DTA was 10.18685.

## step2: treat the .PS file into .ma file
```bash
trait=$1; # a specific trait
value=$2; # the SD value

#../filter_info/freq/$trait\.frq.gz: frequency for variants  (can be found in 02-single-variants_GWAS/GWAS)
perl ../filter_info/filter_marker.pl ../filter_info/freq/$trait\.frq.gz > wanted_allele_$trait
#../chr_PS/$trait\_chr*ps: the GWAS result for all variants
# effect allele, the minor allele for each variants (A1 allele)
cat ../chr_PS/$trait\_chr*ps |perl change_PS_to_summary.pl - effet_allele ../filter_info/freq/$trait\.frq.gz wanted_allele_$trait $value > $trait\.summary
```

## step3: get_indepedent_association.sh
```bash
trait=$1
SNP=../filter_info/analsis_variants 
gcta64  --bfile $SNP  --maf 0.001 --cojo-file ${trait}.summary --cojo-slct --out ${trait}_chr1 --chr 1 --cojo-p 1e-7 &
