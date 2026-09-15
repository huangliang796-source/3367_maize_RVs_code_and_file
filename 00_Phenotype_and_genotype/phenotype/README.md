
# BLUP estimation
Input format, each column presents "#Lines Env1  Env2"
```
A1017	76.00 	66.00 
A1044	86.00 	76.00 
A1078	75.00 	67.00 
A1139	99.00 	92.00 
A1459	83.00 	76.00 
A1466	95.00 	88.00 
A1470	86.00 	75.00 
A1472	88.00 	76.00 
A1502	80.00 	69.00 
A1777	69.00 	63.00 
```

##Codes
```bash
perl change_table_to_blup_format.pl DTA_table DTA_blup_format
Rscript multi_envs_no_rep_phenotype_blup2.r  DTA_format DTA_blup

```
