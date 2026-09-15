#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if(length(args) != 2){
	    stop("Usage: Rscript wc_bootstrap.R input.txt output.txt")
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

cat("Running bootstrap...\n")

# ----------------------------
# Set parameters safely
# ----------------------------
set.seed(2020)

# 如果需要，可以显式指定 nsim、alpha
out_BOOT <- BR_ss(
		      summary_data = dat[, c("rsid","beta","se")],
		          seed_opt = TRUE,
		          seed = 2020
			  )

# ----------------------------
# ----------------------------
write.table(out_BOOT,
	                file = output,
			            quote = FALSE,
			            sep = "\t",
				                row.names = FALSE)

cat("Finished.\n")
cat("Results written to:", output, "\n")
