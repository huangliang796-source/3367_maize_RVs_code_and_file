# Gene-based testing for DTA

## step1: get relationship of gene and variants
```bash
##get rare variants
SNP_PATH=~/HuangL/3367/raw_data/genotype/SNP_INDEL_SV_treated
cat $SNP_PATH\.bim  |grep -v SV -i |awk '{print $2}' > variants_wanted
plink --allow-no-sex --bfile  $SNP_PATH  --extract   variants_wanted --out  maize_SNP_rare --make-bed  --maf 0.00001  --max-maf 0.001 --geno 0.5

##get promoters of genes
perl get_promoter.pl  ~/HuangL/3367/Referecence/B73_v4_gene B73_v4_gene_promoter 1000 
sed 's/gene://g' B73_v4_gene_promoter > B73_v4_gene_promoter_tmp
mv B73_v4_gene_promoter_tmp B73_v4_gene_promoter
awk '{print $1"\t"$4"\t"$4"\t"$2}' maize_SNP_rare.bim > merged_rare_SNP

##get relationship between promoter and gene
bedtools intersect -a B73_v4_gene_promoter -b merged_rare_SNP -wao  |perl generate_SNP_set.pl - > SNP_set_info

SNP=maize_SNP_rare
awk '{print $2}' SNP_set_info  > SNP_wanted
plink --bfile $SNP --extract SNP_wanted --make-bed --out merged_rare_SNP_gene_region

```

## step2: get population structure and kinship
```
#same file with 02-single-variants-GWAS
mkdir -p PCA_and_kinship
ln -s ~/HuangL/3367/raw_data/PCA_and_corrlation/PCA PCA_and_kinship/PCA
perl generate_file_for_covariant.pl ~/HuangL/3367/raw_data/PCA_and_corrlation/PCA  merged_rare_SNP_gene_region.fam  PCA_and_kinship/merged_rare_SNP_High_and_Median.covariant
ln -s ~/HuangL/3367/raw_data/PCA_and_corrlation/kinship PCA_and_kinship/kinship
```

## step3: get SDD format file for SKAT-O
```
Rscript Rscript_generate_SSD_file.r
```

## step4: get phenotypes
```
fold=~/HuangL/3367/raw_data/phenotype/
perl combine_fam_with_phenotype.pl merged_rare_SNP_gene_region.fam $fold/DTA >phenotype/DTA.fam
```

## step5: perfomed association testing
```
Rscript Rscript_for_SKAT_test_PC_K.r  DTA
```
