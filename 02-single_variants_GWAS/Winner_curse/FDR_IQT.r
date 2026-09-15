#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if(length(args) != 2){
	    stop("Usage: Rscript wc_fiqt.R input.txt output.txt")
}

input <- args[1]
output <- args[2]

suppressPackageStartupMessages({
	    library(winnerscurse)
})

dat <- read.table(input, header = TRUE, stringsAsFactors = FALSE)

colnames(dat)[colnames(dat) == "SNP"] <- "rsid"
colnames(dat)[colnames(dat) == "b"]   <- "beta"

cat("Running FDR-IQT...\n")

out_FIQT <- FDR_IQT(
		        summary_data = dat[, c("rsid","beta","se","p")],
			    min_pval = 1e-300
			)

write.table(out_FIQT,
	                file = output,
			            quote = FALSE,
			            sep = "\t",
				                row.names = FALSE)

cat("Finished.\n")
