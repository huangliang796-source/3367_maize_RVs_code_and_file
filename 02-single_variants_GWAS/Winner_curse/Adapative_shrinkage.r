#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

if(length(args) != 2){
	    stop("Usage: Rscript ashr_shrink.R input.txt output.txt")
}

input <- args[1]
output <- args[2]

suppressPackageStartupMessages({
	    library(ashr)
})

cat("Reading data...\n")

dat <- read.table(
		      input,
		          header = TRUE,
		          stringsAsFactors = FALSE
			  )

required_cols <- c("SNP","b","se")

if(!all(required_cols %in% colnames(dat))){
	    stop("Input file must contain columns: SNP B SE")
}

cat("Running adaptive shrinkage...\n")

fit <- ash(
	       betahat = dat$b,
	           sebetahat = dat$se,
	           method = "fdr"
		   )

dat$B_SHRINK <- get_pm(fit)
dat$SE_SHRINK <- get_psd(fit)
dat$LFSR <- get_lfsr(fit)

write.table(
	        dat,
		    file = output,
		    quote = FALSE,
		        sep = "\t",
		        row.names = FALSE
			)

cat("Finished.\n")
cat("Results written to:", output, "\n")
