# Admixture analysis
```bash
SNP_PATH=/data04/work_redo/SNP_set/combine_biallelic_3367/Hardy_Weinberg//merged_SNP_Hardy_W_sysnon
plink --allow-no-sex --bfile  $SNP_PATH   --maf 0.01  --make-bed --out merged_SNP_Hardy_W_sysnon_filtered --geno 0.5

SNP_PATH=./merged_SNP_Hardy_W_sysnon_filtered.bed
for((j=2;j<=24;j++));
do
	admixture --cv $SNP_PATH $j -j3 | tee log${j}.out &
done	
wait
```

# phylogenetic_tree
```bash
SNP_PATH=/data04/work_redo/SNP_set/combine_biallelic_3367/Hardy_Weinberg//merged_SNP_Hardy_W_sysnon
plink --allow-no-sex --bfile  $SNP_PATH   --maf  0.05 --geno 0.5 --distance square 1-ibs --out merged_SNP_Hardy_W_sysnon_IBS
current_fold=`pwd`
SNP_prefix=merged_SNP_Hardy_W_sysnon_IBS
perl convert_IBS_distance_matrix_into_phylip_input_format.pl $SNP_prefix\.mdist $SNP_ped > ./infile
echo -e "$current_fold/infile\nN\nY" > UPGMA_tree.bar
neighbor < UPGMA_tree.bar > neighbor.UPGMA.log
mv outfile output/file.UPGMA
mv outtree output/UPGMA.nwk
```

