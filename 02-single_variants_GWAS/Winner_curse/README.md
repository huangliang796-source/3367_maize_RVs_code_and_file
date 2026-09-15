## Winner's curse
```bash
#Rscript $code.r $input $output
Rscript BRSS.r DTA.ps DTA.ps.BRSS
Rscript CL_method.r DTA.ps DTA.ps.CL
Rscript EBayes.r DTA.ps DTA.ps.EB
Rscript FDR_IQT.r DTA.ps DTA.ps.FDRIQT
Rscript  Adapative_shrinkage.r  $name.ps $name.ps.Ashr

```

The corrected effect size were included in the output files,such as "DTA.ps.BRSS"
