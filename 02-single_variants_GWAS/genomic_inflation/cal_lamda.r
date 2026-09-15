ARGV <- commandArgs()
gwasResults=read.table(ARGV[6],header=TRUE)
p_values <- gwasResults$P

##GWAS thredshold
limit=0.0000001
p_values<- p_values[p_values> limit]




chi_sq <- qchisq(1 - p_values, df=1) 
valid_chi <- chi_sq[!is.na(chi_sq) & p_values > 0]
median_obs <- median(valid_chi)
median_theory <- qchisq(0.5, df=1)  # 结果为0.4549

lambda <- median_obs / median_theory
cat(ARGV[6],"\t", lambda, "\n")
