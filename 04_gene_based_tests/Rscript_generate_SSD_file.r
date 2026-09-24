library("SKAT")
File.Bed<-"merged_rare_SNP_gene_region.bed"
File.Bim<-"merged_rare_SNP_gene_region.bim"
File.Fam<-"merged_rare_SNP_gene_region.fam"
File.SetID<-"SNP_set_info"
File.SSD<-"merged_rare_SNP_gene_region.SSD"
File.Info<-"merged_rare_SNP_gene_region.SSD.info"

Generate_SSD_SetID(File.Bed, File.Bim, File.Fam, File.SetID, File.SSD, File.Info)


