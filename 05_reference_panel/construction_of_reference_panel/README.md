# Construction of reference panel
## step1: format convertion
```bash
SNP=/public1/home/sc30797/huangliang/3000_maize/combine_bed/SNP_INDEL_SV
cat $SNP.bim |grep -v Indel |grep -v SV  |awk '{print $2}' > wanted.variants
plink --allow-no-sex --bfile $SNP    --make-bed --out 3367_SNP  --extract wanted.variants --mac 5 --geno 0.8
SNP=3367_SNP
plink --bfile $SNP --chr 1 --make-bed --out chr1
plink --bfile chr1 --recode vcf-iid bgz  --out chr1
bcftools view chr1.vcf.gz  -O b  -o chr1.bcf
bcftools index chr1.bcf
```
## step2: self-imputation with Eagle
```bash
eagle=/public1/home/sc30797/huangliang/software/Eagle/Eagle_v2.4.1/eagle
cat chr1.bim   |awk '{print $1" "$4" 1 "$4/1000000}' |cat header - |gzip - >chr1.gmap.gz
$eagle --vcf=chr1.bcf  --geneticMapFile=chr1.gmap.gz  --outPrefix=chr1_phased  --numThreads 64
```
