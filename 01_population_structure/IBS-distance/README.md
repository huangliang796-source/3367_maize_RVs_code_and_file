# Calculate of IBS among genomes with SNP
```bash
plink --bfile  $SNP_PATH --maf 0.01 -geno 0.5 --distance square 1-ibs flat-missing --out SNP
```
