## GREML analysis in temperate and tropical genomes independently

## step1: get genotype

```bash
SNP_PATH=~/HuangL/3367/raw_data/genotype/SNP_INDEL_SV_treated
perl get_sample_id.pl  ~/HuangL/3367/raw_data/phenotype/temperate/combine.list $SNP_PATH\.fam > temperate_list
perl get_sample_id.pl  ~/HuangL/3367/raw_data/phenotype/tropical/tropical.list $SNP_PATH\.fam > tropical_list
plink --allow-no-sex --bfile $SNP_PATH --noweb --keep temperate_list    --make-bed --out temperate --maf 0.00001 --geno 0.5
plink --allow-no-sex --bfile $SNP_PATH --noweb --keep tropical_list     --make-bed --out tropical  --maf 0.00001 --geno 0.5
```

## step2: get PCA for each group

```bash
variant=temperate
plink --allow-no-sex --bfile  $variant  --maf 0.05  --make-bed --out temperate_common
plink --allow-no-sex --bfile  temperate_common  --indep-pairwise 50 20 0.5
plink --allow-no-sex --bfile  temperate_common --extract plink.prune.in --make-bed --out  temperate_common_LD

#--autosome-num 10 --autosome --make-grm
gcta64 --bfile temperate_common_LD --autosome-num 10 --autosome  --make-grm  --out temperate_common_LD  --thread-num  12
gcta64 --grm   temperate_common_LD  --pca 10 --out  temperate_common_LD --thread-num  12
/bin/rm -rf temperate_common.???


variant=tropical
plink --allow-no-sex --bfile  $variant  --maf 0.05  --make-bed --out tropical_common
plink --allow-no-sex --bfile  tropical_common  --indep-pairwise 50 20 0.5
plink --allow-no-sex --bfile  tropical_common --extract plink.prune.in --make-bed --out  tropical_common_LD

gcta64 --bfile tropical_common_LD --autosome-num 10 --autosome  --make-grm  --out tropical_common_LD  --thread-num  12
gcta64 --grm   tropical_common_LD  --pca 10 --out  tropical_common_LD --thread-num  12
/bin/rm -rf tropical_common.???
```

## step3: get grm-matrix

```bash
SNP=temperate
plink -allow-no-sex --bfile  $SNP  --maf 0.05  --make-bed --out temperate_common
plink -allow-no-sex --bfile  $SNP  --mac 10 --max-maf 0.04999999 --make-bed --out temperate_rare

SNP=tropical
plink -allow-no-sex --bfile  $SNP  --maf 0.05  --make-bed --out tropical_common
plink -allow-no-sex --bfile  $SNP  --mac 10 --max-maf 0.04999999 --make-bed --out tropical_rare


gcta64 --bfile temperate_common --autosome-num 10 --autosome  --make-grm-inbred --out temperate_common   --thread-num  12
gcta64 --grm   temperate_common         --pca 10 --out  temperate_common --thread-num  12
gcta64 --bfile temperate_rare --autosome-num 10 --autosome  --make-grm-inbred --out temperate_rare --thread-num  12
gcta64 --grm   temperate_rare          --pca 10 --out  temperate_rare  --thread-num  12

gcta64 --bfile tropical_common --autosome-num 10 --autosome  --make-grm-inbred --out tropical_common   --thread-num  6
gcta64 --grm   tropical_common         --pca 10 --out  tropical_common --thread-num  6
gcta64 --bfile tropical_rare --autosome-num 10 --autosome  --make-grm-inbred --out tropical_rare --thread-num  6
gcta64 --grm   tropical_rare          --pca 10 --out  tropical_rare  --thread-num  6

```
## step4: Heritability estimation

```bash
cat temperate_common_LD.eigenvec |sed 's/ /\t/g' |cut -f 1-12 |sed 's/\t/ /g' > temperate_PCA.eigenvec
gcta64 --mgrm temperate_grm_matrix --qcovar  temperate_PCA.eigenvec   --reml-maxit 1000 --pheno phenotype/DTA  --reml  --thread-num 24  --out 3367_noC_temp/DTA

cat tropical_common_LD.eigenvec |sed 's/ /\t/g' |cut -f 1-12 |sed 's/\t/ /g' > tropical_PCA.eigenvec
gcta64 --mgrm tropical_grm_matrix --qcovar  tropical_PCA.eigenvec   --reml-maxit 1000 --pheno phenotype/DTA  --reml  --thread-num 24  --out 3367_noC_trop/DTA
```


