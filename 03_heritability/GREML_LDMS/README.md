# Estimate the heritability with GREML_LDMS model

## step1: calculate PCA
Same with the 01_population_structure

## step2: calculate the LDScore
```bash
SNP=~/GWAMA_FT/raw_genotype/raw_data01_3367/genotype/SNP_INDEL_SV
plink --bfile $SNP --chr 1 --make-bed --out chr1 --geno 0.5 --mac 10
gcta64 --bfile chr1  --ld-score --ld-wind 5000 --ld-rsq-cutoff 0 --ld-score-adj --out chr1 --thread-num 12

cat chr10*ld |head -n 1 > LD_score_file_header
cat chr*ld |grep -v MAF |cat LD_score_file_header - > LD_score_file

# divide variants into two files; snp_group1.txt: low LDscores ; snp_group4.txt: High LDscores
Rscript strafied_LD.R
```

## step3: calculate GRM matrix for each bin
```bash
plink --bfile $SNP  --make-bed --out SNP_list1.common --geno 0.5 --mac 10 --maf 0.05 --extract snp_group1.txt 
plink --bfile $SNP  --make-bed --out SNP_list4.common --geno 0.5 --mac 10 --maf 0.05 --extract snp_group4.txt 
plink --bfile $SNP  --make-bed --out SNP_list1.rare  --geno 0.5 --mac 10 --max-maf 0.049999  --extract snp_group1.txt 
plink --bfile $SNP  --make-bed --out SNP_list4.rare  --geno 0.5 --mac 10 --max-maf 0.049999  --extract snp_group4.txt 

gcta64 --bfile SNP_list1.common  --autosome-num 10 --autosome  --make-grm-inbred --make-grm-alg 1  --out SNP_list1.common  --thread-num  32 
gcta64 --bfile SNP_list4.common  --autosome-num 10 --autosome  --make-grm-inbred --make-grm-alg 1  --out SNP_list4.common  --thread-num  32 
gcta64 --bfile SNP_list1.rare  --autosome-num 10 --autosome  --make-grm-inbred --make-grm-alg 1  --out SNP_list1.rare  --thread-num  32 
gcta64 --bfile SNP_list4.rare  --autosome-num 10 --autosome  --make-grm-inbred --make-grm-alg 1  --out SNP_list4.rare  --thread-num  32
```

## step4: estimated hreitability 

