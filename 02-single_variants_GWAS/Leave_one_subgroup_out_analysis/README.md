# Leave-one_subgroups_analysis 
## using ZmAGO5c as example

## step1: removed phenotype for one subgroups
```bash
cat list  |awk -F "/" '{print "perl masker_phenotype.pl /public/home/hll/3367_RVs/Data_copy_of_HPC//raw_data/phenotype/DTA "$0"> phenotype/No_"$NF}' |sh -
```
## step2: re-GWAS
```bash
SNP=/public/home/hll/3367_RVs/Data_copy_of_HPC//raw_data/genotype/SNP_INDEL_SV_treated
zcat  ../../../COJO2_common_top10/DTA.summary.gz |cut -f 1 |sed '1d' |grep ^5 > wanted_variants
plink --bfile $SNP --make-bed --out analsis_variants --geno 0.5   --maf 0.000001 --chr 5 --from-bp 3104429 --to-bp 5104429 --extract wanted_variants
plink  --bfile analsis_variants  --map3 --noweb --missing-genotype 0 --recode 12  transpose  --output-missing-genotype 0 --out analsis_variants


genotype=analsis_variants
PCA=/public/home/hll/3367_RVs/Data_copy_of_HPC/raw_data/PCA_and_corrlation/PCA
Kinship=/public/home/hll/3367_RVs/Data_copy_of_HPC/raw_data/PCA_and_corrlation/kinship
emmax=~/Software/emmax-intel-binary-20120210/emmax-intel64
$emmax   -v -d 4 -t $genotype -p $phenotype/DTA -c PCA -k $Kinship -o Ago5c_DTA &

# for each subgroups removed
$emmax   -v -d 4 -t $genotype -p phenotype/No_A632-type -c $PCA -k $Kinship -o No_A632-type
$emmax   -v -d 4 -t $genotype -p phenotype/No_High-latitude-I -c $PCA -k $Kinship -o No_High-latitude-I
$emmax   -v -d 4 -t $genotype -p phenotype/No_High-latitude-II -c $PCA -k $Kinship -o No_High-latitude-II
$emmax   -v -d 4 -t $genotype -p phenotype/No_Iodent -c $PCA -k $Kinship -o No_Iodent
$emmax   -v -d 4 -t $genotype -p phenotype/No_Iodent-related -c $PCA -k $Kinship -o No_Iodent-related
$emmax   -v -d 4 -t $genotype -p phenotype/No_Lancaster -c $PCA -k $Kinship -o No_Lancaster
$emmax   -v -d 4 -t $genotype -p phenotype/No_Oh43-type -c $PCA -k $Kinship -o No_Oh43-type
$emmax   -v -d 4 -t $genotype -p phenotype/No_P-group -c $PCA -k $Kinship -o No_P-group
$emmax   -v -d 4 -t $genotype -p phenotype/No_Reid -c $PCA -k $Kinship -o No_Reid
$emmax   -v -d 4 -t $genotype -p phenotype/No_Reid-related -c $PCA -k $Kinship -o No_Reid-related
$emmax   -v -d 4 -t $genotype -p phenotype/No_Tropical-I -c $PCA -k $Kinship -o No_Tropical-I
$emmax   -v -d 4 -t $genotype -p phenotype/No_Tropical-II -c $PCA -k $Kinship -o No_Tropical-II
$emmax   -v -d 4 -t $genotype -p phenotype/No_Tropical-III -c $PCA -k $Kinship -o No_Tropical-III
$emmax   -v -d 4 -t $genotype -p phenotype/No_Tropical-IV -c $PCA -k $Kinship -o No_Tropical-IV
$emmax   -v -d 4 -t $genotype -p phenotype/No_Tropical-V -c $PCA -k $Kinship -o No_Tropical-V
$emmax   -v -d 4 -t $genotype -p phenotype/No_Tropical-VI -c $PCA -k $Kinship -o No_Tropical-VI
$emmax   -v -d 4 -t $genotype -p phenotype/No_Tropical-VII -c $PCA -k $Kinship -o No_Tropical-VII
$emmax   -v -d 4 -t $genotype -p phenotype/No_TSPT -c $PCA -k $Kinship -o No_TSPT
$emmax   -v -d 4 -t $genotype -p phenotype/No_Waxy -c $PCA -k $Kinship -o No_Waxy

```
