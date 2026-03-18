args <- commandArgs()
file=paste("/public/home/s20223010040/HuangL/3367/raw_data/phenotype/",args[6],sep="")
aa=read.table(file)
value=aa$V3
value <- na.omit(value)
SD=sd(value)
cat(args[6],SD,"\n")
