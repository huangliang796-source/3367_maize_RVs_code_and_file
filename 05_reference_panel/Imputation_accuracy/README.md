## step1: obtain sample list randomly


## step2: get downsampled-vcf for these samples
```bash
SNP=~/HuangL/3367/raw_data/genotype/SNP_INDEL_SV
cat $SNP.bim |grep -v Indel |grep -v SV  |awk '{print $2}' > wanted.variants
plink --allow-no-sex --bfile $SNP    --make-bed --out 3367_SNP -mac 5 --extract wanted.variants --geno 0.8
SNP=3367_SNP
plink --bfile $SNP --chr 1 --make-bed --out chr1
vcftools --gzvcf chr1.vcf.gz  --recode --recode-INFO-all --stdout  --keep wanted_samples |bgzip > chr1.vcf.gz
# SNP_v4_v2_pos_relationshp: 680K polymorphic sites previously revealed by GBS
perl get_pos.pl chr1.vcf.gz SNP_v4_v2_pos_relationshp  |bgzip > chr1.GBS.vcf.gz
bcftools index chr1.GBS.vcf.gz  
```

## step3: removal genetic-related samples from reference panel
```bash
#detail of IBS calculation can be found in 01_population_structure/IBS-distance
perl get_pairs_with_a_closer_relationship.pl  SNP.mdist SNP.mdist.id 0.05  IBS_close_sample_pairs
cat wanted_samples|cut -f 1 |perl get_target_pairs.pl   IBS_close_sample_pairs  - |awk '{print $1"\n"$2}' > close_pairs_with_target
cat wanted_samples|cut -f 1 |cat - close_pairs_with_target |sort |uniq > removed_samples
#phased vcf can be found in 05_reference_panle/construction_of_reference_panel
vcftools --gzvcf ../../panel/chr1_phased.vcf.gz  --recode --recode-INFO-all --stdout  --remove removed_samples |bgzip > chr1_phased.vcf.gz
bcftools index chr1_phased.vcf.gz
```
## step4: impute missing genotypes with beagle
```bash
beagle=/public/home/s20223010040/HuangL/software/beagle/beagle.08Feb22.fa4.jar
java -Xmx240g -jar $beagle gt=chr1.GBS.vcf.gz   ref=../../treated_panel/chr1_phased.vcf.gz  out=chr1_GBS_phased  nthreads=24
```

## step5 estimated the imputation accuracy
```
#Ture genotype:  chr1.vcf.gz
#Imputed genotype: Chr1_GBS_phased.vcf.gz
perl treat_raw.pl chr1.vcf.gz > chr1_raw
perl treat_phased.pl chr1_GBS_phased.vcf.gz > chr1_phased
/bin/bash row_correlation.sh chr1_raw chr1_phased chr1_result
```
zcat raw_$range\.vcf.gz |perl add_miss_rate.pl  $range\_result ~/HuangL/3367/raw_data/genotype/SNP_INDEL_SV.frq -  > $range\_result_treated





