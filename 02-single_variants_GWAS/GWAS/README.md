# Single-variant GWAS

## Step1: calculate PCA
Same with the 01/population/PCA

## Step2: calculate Kinship
```bash
cat ../SNP_INDEL_SV.bim |awk '{print $2}' |grep -v Indel |grep -v SV > wanted_variants
plink --allow-no-sex --bfile ../SNP_INDEL_SV  --extract wanted_variants --make-bed --out  GWAS_SNP 
plink --allow-no-sex --bfile GWAS_SNP  --noweb --maf 0.05 --geno 0.5 --make-bed --out GWAS_SNP_miss0.5_maf_0.05_temp
plink --allow-no-sex --bfile GWAS_SNP_miss0.5_maf_0.05_temp --indep-pairwise 50 20 0.5
plink --allow-no-sex --bfile GWAS_SNP_miss0.5_maf_0.05_temp  --extract plink.prune.in --make-bed --out GWAS_SNP_miss0.5_maf_0.05

plink --allow-no-sex --bfile GWAS_SNP_miss0.5_maf_0.05  --geno 0.1 --make-bed --out GWAS_SNP_miss0.9_maf_0.05
plink  --bfile  GWAS_SNP_miss0.9_maf_0.05  --map3 --noweb --missing-genotype 0 --recode 12  transpose  --output-missing-genotype 0 --out GWAS_SNP_miss0.9_maf_0.05
 ~/HuangL/software/emmax/emmax-beta-07Mar2010/emmax-kin  -v -h -s -d 10  GWAS_SNP_miss0.9_maf_0.05

```
