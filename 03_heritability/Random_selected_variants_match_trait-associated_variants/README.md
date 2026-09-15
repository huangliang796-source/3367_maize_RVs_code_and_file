# Get the randomly selected variants that matched with trait-associated rare variants in MAF and LDscores

## step1: keep_low_LD_SNP_only
```bash
plink --bfile $SNP --make-bed --out ALL --geno 0.5
plink --bfile ALL --indep-pairwise  500 50 0.8  --out pruned_result
ref_allele=~/3367_RVs/Data_copy_of_HPC//raw_data/genotype/ref_allele
plink --bfile $SNP --extract wanted_variants  --a2-allele $ref_allele 1 2 '#'  --recode vcf-iid bgz --out all_allele
plink --bfile $SNP --extract pruned_result.prune.in  -a2-allele $ref_allele 1 2 '#' --recode vcf-iid bgz  --out  variant_frq_after_LD_prune_500kb_50_0.8
vcftools --gzvcf variant_frq_after_LD_prune_500kb_50_0.8.vcf.gz --freq  --out variant_frq_after_LD_prune_500kb_50_0.8 
cat variant_frq_after_LD_prune_500kb_50_0.8.frq  |grep -v CHROM  |sed 's/:/\t/g' |perl get_alt_freq.pl - ~/3367_RVs/Data_copy_of_HPC//raw_data/genotype/ref_allele > variant_frq_after_LD_prune_500kb_50_0.8.treated_AF
```

## step2: 
cat trust_loci |awk '$2<0.05 {print " perl get_match_snp.pl variant_frq_after_LD_prune_500kb_50_0.8.treated_AF "$2" "$1" 0.002 "$1"_out 100000"}' > command.sh
~/Software/anaconda3/envs/Base/bin/parallel -j 20 <  command.sh
ls *_out  |sed 's/_out//g' |awk '{print " perl get_matched_SNP_LDscore.pl "$NF"_out LDscore_Bin_infor/410_site_group_info LDscore_Bin_infor/SNP_group_info  "$NF" > "$NF"_out2"}'  > command_LD 
