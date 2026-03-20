# Estimated the heritability with GREML_MS model

## Step1: Calculate the PCA
Same with the 01_population_structure/PCA

## Step2: Calculate the GRM matrix for variants belong to different MAF categories
```bash
SNP=~/HuangL/3367/raw_data/genotype/SNP_INDEL_SV
plink -allow-no-sex --bfile  $SNP  --maf 0.05  --make-bed --out variant_commom --geno 0.5
plink -allow-no-sex --bfile  $SNP  --mac 10 --max-maf 0.04999999 --make-bed --out variant_rare --geno 0.5
gcta64 --bfile ./variant_commom --autosome-num 10 --autosome  --make-grm-inbred  --out common  --thread-num  40
gcta64 --bfile ./variant_Rare --autosome-num 10 --autosome  --make-grm-inbred --out Rare  --thread-num  40
```

## Step3: Estimated the heritability with GCTA
```bash
gcta64 --mgrm grm_matirx_file --qcovar  PCA.eigenvec   --reml-maxit 1000 --pheno phenotype/DTA  --reml  --thread-num 32  --out 3367_no_constrain/DTA
```


