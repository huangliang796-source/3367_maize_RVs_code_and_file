# Within_group_permutation_analysis

## step1: phenotype permutation
```bash
for i in {1..3000}
do
  perl get_random.pl sample_list /public/home/hll/3367_RVs/Data_copy_of_HPC/raw_data/phenotype/DTA $i > DTA/DTA$i 
done
```

## step2: Estimation of heritability
```
for i in {1..3000}
do
  # grm_matrix_file1: the same two grm matrix used in GREML_MS/ analysis
  # final_cov_19sub： the PCA and subgroups membership info
  gcta64 --mgrm grm_matirx_file1 --qcovar  final_cov_19sub   --reml-maxit 1000 --pheno DTA/DTA$i --reml  --thread-num 32  --out DTA_shuff_result_two_comp/DTA$i
done
```
