# Calculate Fst
```bash
vcftools --gzvcf $input_vcf --weir-fst-pop class1_list --weir-fst-pop class2_list --fst-window-size 100000 --fst-window-step 100000 --out Fst_between_1_2  2> Fst_between_1_2.log
```

# Calculate recent genetic exchange
  ## step1 calculate number of f2 among two genomes
  ```bash
  perl get_SNP_only_in_two_sample.pl  /data04/work_redo/3367_sorted_jvcf_HW/VCF_10_SNP_after_HF_raw_3367_sorted_F.vcf.gz  > chr10_doubleton_SNP
```
## step2 calculate number of f2 among two groups
  ```bash
  cat chr*_doubleton_SNP |perl assign_SNP_into_class_pairs.pl - sample_with_class_class19 > doubleton_share_pattern
```
## step3 normalize inter-group f2 number by the total f2 detected in corresponding group
  ```bash
  perl get_norm.pl doubleton_share_pattern doubleton_share_pattern_nor
```
