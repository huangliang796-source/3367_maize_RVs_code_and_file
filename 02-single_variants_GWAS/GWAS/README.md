# Single-variant GWAS

## Step1: calculate PCA
Same with the 01/population/PCA

## Step2: calculate Kinship matrix
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
## Step3: GWAS analysis with EMMAX
```bash
SNP=SNP_INDEL_SV
plink  --bfile  $SNP --map3 --noweb --missing-genotype 0 --recode 12  transpose  --output-missing-genotype 0 --out GWAS_final --geno 0.5 --mac 10
emmax=/public/home/s20223010040/HuangL/software/emmax/emmax-intel-binary-20120210/emmax-intel64
$emmax   -v -d 10 -t GWAS_final -p $phenotype/DTA -c $PCA -k $Kinship -o DTA
```

## Step4: filter variants without enough phenotypic data for the minor allele
```bash
plink --bfile $SNP --make-bed --out analsis_variants --geno 0.5 --mac 10

genotype=analsis_variants
trait=$1
grep -v NA ~/HuangL/3367/raw_data/phenotype/$trait > trait/$trait
plink --bfile $genotype --freq --out freq/$trait --keep trait/$trait  --memory 8192 --threads 3
bgzip freq/$trait\.frq
perl filter_marker.pl  freq/$trait\.frq.gz > wanted_variants
```
Only variants in the wanted_variants file were included for further analysis for a specific trait

Follow this pipeline, the output .ps file looks like that:
```
9_2639392	-14.19234009	3.132380403	6.117632368e-06
9_5013179	26.23450928	5.923025444	9.814494878e-06
9_11709262	12.84959485	2.891370868	9.16375838e-06
9_11709266	13.48084383	2.715383373	7.291047566e-07
9_22704337	4.087722415	0.9207483298	9.358402946e-06
9_30055545	46.70487053	8.708924705	8.849966164e-08
9_31684755	8.61740506	1.940042468	9.259643868e-06
```
where the second and third column presents the effect size and SE(beta).

Due to the treatment of "--make-bed" with out specific the the A1 allele, the A1 allele of each variants was the minor allele.

Due to the treatment of "--recode 12  transpose  --output-missing-genotype 0", the effect size given by EMMAX was those of the major allele (A2 allele).




