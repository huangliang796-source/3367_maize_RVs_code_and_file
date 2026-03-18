# PCA based on common SNP after LD pruning

```bash
cat ../SNP_INDEL_SV.bim |awk '{print $2}' |grep -v Indel |grep -v SV > wanted_variants
plink --allow-no-sex --bfile ../SNP_INDEL_SV  --extract wanted_variants --make-bed --out  GWAS_SNP 
plink --allow-no-sex --bfile GWAS_SNP  --noweb --maf 0.05 --geno 0.5 --make-bed --out GWAS_SNP_miss0.5_maf_0.05_temp
plink --allow-no-sex --bfile GWAS_SNP_miss0.5_maf_0.05_temp --indep-pairwise 50 20 0.5
plink --allow-no-sex --bfile GWAS_SNP_miss0.5_maf_0.05_temp  --extract plink.prune.in --make-bed --out GWAS_SNP_miss0.5_maf_0.05
gcta64 --bfile GWAS_SNP_miss0.5_maf_0.05 --autosome-num 10 --autosome --make-grm --out GWAS_SNP_miss0.5_maf_0.05 --thread-num  4
gcta64 --grm   GWAS_SNP_miss0.5_maf_0.05 --pca 20 --out  GWAS_SNP_miss0.5_maf_0.05  --thread-num  4
```
