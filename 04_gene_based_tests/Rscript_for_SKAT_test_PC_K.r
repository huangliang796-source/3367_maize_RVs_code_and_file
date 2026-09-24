library("SKAT")
args <- commandArgs()
trait=args[6]
File.Cov<-"PCA_and_kinship/merged_rare_SNP_High_and_Median.covariant"
File.SetID<-"SNP_set_info"
File.SSD<-"merged_rare_SNP_gene_region.SSD"
File.Info<-"merged_rare_SNP_gene_region.SSD.info"
Kinship<-read.table("PCA_and_kinship/kinship")
Kinship<-as.matrix(Kinship)

#Generate_SSD_SetID(File.Bed, File.Bim, File.Fam, File.SetID, File.SSD, File.Info)
File.Fam=paste("phenotype/",trait,".fam",sep="")
FAM<-Read_Plink_FAM_Cov(File.Fam, File.Cov, Is.binary=FALSE, cov_header=TRUE)
SSD.INFO<-Open_SSD(File.SSD, File.Info)

#obj<-SKAT_Null_Model(Phenotype ~ PC1+PC2+PC3+PC4 , out_type="C",data=FAM, n.Resampling=1000, type.Resampling="bootstrap", Adjustment=FALSE)
#obj<-SKAT_Null_Model(Phenotype ~ PC1+PC2+PC3+PC4 , out_type="C",data=FAM, n.Resampling=1000, type.Resampling="bootstrap", Adjustment=FALSE)
obj<-SKAT_NULL_emmaX(Phenotype ~ PC1+PC2+PC3+PC4,data=FAM ,K=Kinship)

out<-SKAT.SSD.All(SSD.INFO, obj)
#out<-Resampling_FWER(out,FWER=0.05)
output=paste("result/",trait,"2.txt",sep="")
write.table(out$result, file=output, col.names=TRUE, row.names=FALSE)

#obj<-SKAT_NULL_emmaX(Phenotype ~ PC1+PC2+PC3+PC4,data=FAM ,K=Kinship)
#out.skat<-SKATBinary.SSD.All(SSD.INFO, obj, method="SKAT")
#FWER_result.skat=Resampling_FWER(out.skat,FWER=0.05)

#out.skato<-SKATBinary.SSD.All(SSD.INFO, obj, method="SKATO")
#FWER_result.skato=Resampling_FWER(out.skat,FWER=0.05)

#Get_EffectiveNumberTest(out.skat$results$MAP, alpha=0.05)
#QQPlot_Adj(out.skat$results$P.value, out.skat$results$MAP)

#Get_EffectiveNumberTest(out.skato$results$MAP, alpha=0.05)
#QQPlot_Adj(out.skato$results$P.value, out.skato$results$MAP)


