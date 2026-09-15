# Conditional_analysis
## using ZmAGO5c as example
## step1: get_genotype_for_target_variants
```bash
zcat /public/home/hll/3367_RVs/Data_copy_of_HPC/raw_data/Panel/vcf/chr5_phased.vcf.gz |head -n 200 |grep CHROM |sed 's/\t/\n/g' > header
tabix /public/home/hll/3367_RVs/Data_copy_of_HPC/raw_data/Panel/vcf/chr5_phased.vcf.gz  5:4104429-4104429 |sed 's/\t/\n/g' |paste header -  |sed 's/0|0/0/g' |sed 's/1|1/2/g' |sed 's/0|1/1/g' |sed 's/1|0/1/g'  |tail -n+10 > ZmAGO5c_leader_SNP
```

## step2: re-GWAS analysis

```bash
SNP=/public/home/hll/3367_RVs/Data_copy_of_HPC//raw_data/genotype/SNP_INDEL_SV_treated
zcat  ../../../COJO2_common_top10/DTA.summary.gz |cut -f 1 |sed '1d' |grep ^5 > wanted_variants

# Only perform GWAS for variants 1Mb around
plink --bfile $SNP --make-bed --out analsis_variants --geno 0.5   --maf 0.000001 --chr 5 --from-bp 3104429 --to-bp 5104429 --extract wanted_variants
plink  --bfile analsis_variants  --map3 --noweb --missing-genotype 0 --recode 12  transpose  --output-missing-genotype 0 --out analsis_variants

# add target variants as co-variate
PCA=/public/home/hll/3367_RVs/Data_copy_of_HPC/raw_data/PCA_and_corrlation/PCA
perl add_cov.pl $PCA ZmAGO5c_leader_SNP  > PCA

Kinship=/public/home/hll/3367_RVs/Data_copy_of_HPC/raw_data/PCA_and_corrlation/kinship
genotype=analsis_variants
phenotype=/public/home/hll/3367_RVs/Data_copy_of_HPC//raw_data/phenotype/

emmax=~/Software/emmax-intel-binary-20120210/emmax-intel64
$emmax   -v -d 4 -t $genotype -p $phenotype/DTA -c PCA -k $Kinship -o Ago5c_DTA &
wait

```
