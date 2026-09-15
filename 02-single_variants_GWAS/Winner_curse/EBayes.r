#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if(length(args) != 2){
	    stop("Usage: Rscript wc_eb.R input.txt output.txt")
}

input <- args[1]
output <- args[2]

suppressPackageStartupMessages({
	    library(winnerscurse)
})

dat <- read.table(input, header = TRUE, stringsAsFactors = FALSE)

colnames(dat)[colnames(dat) == "SNP"] <- "rsid"
colnames(dat)[colnames(dat) == "b"]   <- "beta"

cat("Running empirical bayes...\n")

out_EB <- empirical_bayes(
			      summary_data = dat[, c("rsid","beta","se")]
			      )

write.table(out_EB,
	                file = output,
			            quote = FALSE,
			            sep = "\t",
				                row.names = FALSE)

cat("Finished.\n")
