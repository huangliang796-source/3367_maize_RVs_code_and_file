#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if(length(args) != 2){
	    stop("Usage: Rscript wc_cl.R input.txt output.txt")
}

input <- args[1]
output <- args[2]

suppressPackageStartupMessages({
	    library(winnerscurse)
})

cat("Reading data...\n")
dat <- read.table(input, header = TRUE, stringsAsFactors = FALSE)

# rename
colnames(dat)[colnames(dat) == "SNP"] <- "rsid"
colnames(dat)[colnames(dat) == "b"]   <- "beta"

# ----------------------------
# FILTER (CL only)
# ----------------------------
alpha <- 1e-7
dat <- dat[dat$p < alpha, ]

cat("Running conditional likelihood...\n")

out_CL <- conditional_likelihood(
				     summary_data = dat[, c("rsid","beta","se")],
				         alpha = alpha
				     )

write.table(out_CL,
	                file = output,
			            quote = FALSE,
			            sep = "\t",
				                row.names = FALSE)

cat("Finished.\n")
