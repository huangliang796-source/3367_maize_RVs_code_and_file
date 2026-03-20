lds_seg = read.table("LD_score_file",header=T,colClasses=c("character",rep("numeric",7)))
lds_seg$ldscore_SNP=lds_seg$ldscore
quartiles=summary(lds_seg$ldscore_SNP)

lb1 = which(lds_seg$ldscore_SNP <= quartiles[3])
lb4 = which(lds_seg$ldscore_SNP > quartiles[3])

lb1_snp = lds_seg$SNP[lb1]
lb4_snp = lds_seg$SNP[lb4]

write.table(lb1_snp, "snp_group1.txt", row.names=F, quote=F, col.names=F)
write.table(lb4_snp, "snp_group4.txt", row.names=F, quote=F, col.names=F)
