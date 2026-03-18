# calculate private SNP in each group

## step1 calculate frequency for all SNP in each group
```bash
perl get_ref_alt_SNP_per_class.pl  /data04/work_redo/3367_sorted_jvcf_HW/VCF_10_SNP_after_HF_raw_3367_sorted_F.vcf.gz  sample_with_class_class19 > chr10_SNP_info_for_class
```

## assign class information for private SNP
```bash
perl get_private_SNP.pl  chr10_SNP_info_for_class >>private_SNP
```
## get private SNP number per groups
```bash
cat private_SNP  |awk '{print $NF}'  |sort -n |uniq -c |awk '{print "class"$2"\t"$1}' |paste class_info - 
```
