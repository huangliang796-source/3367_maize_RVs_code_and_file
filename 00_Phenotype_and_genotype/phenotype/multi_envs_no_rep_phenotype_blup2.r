Args <- commandArgs()
input_file=Args[6]
output_file=Args[7]

## load the library for Linear Mixed-Effects Models
library(lme4) 
library(rlang)

## read the phenotype data
pheno = read.table(input_file, sep="\t", header=T) 

## Check to ensure data imported correctly 
str(pheno)
head(pheno)
tail(pheno)

## Attach dataset
attach(pheno)

# Rename variables for ease of use 
VALUE = as.numeric(value) 
LINE = as.factor(line)
ENV = as.factor(env) 

## Calculate variance components
# Linear Model with random effects for variance components
blp = lmer(value ~ (1|LINE) + (1|ENV)+  (1|LINE:ENV), data = pheno, control=lmerControl(check.nobs.vs.nlev = "ignore", check.nobs.vs.rankZ = "ignore", check.nlev.gtr.1 = "ignore", check.nobs.vs.nRE="ignore")) 


# Extract variance components 
summary(blp)

# estimate BLUPS 
blups = ranef(blp) 
# look at output structure
str(blups)

names(blups) 
## blup add the mean 
lines=blups$LINE+blp@beta 
res=data.frame(id=rownames(lines),blup=lines) 
write.table(res, file=output_file, row.names = F, quote = F, sep = "\t") 


