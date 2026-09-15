
# Identification of variations

## Step1: Clean data
```bash
fastp -w 16 --detect_adapter_for_pe --cut_front --cut_tail --in1 ${dir}/${sample}.1.fq.gz --in2 ${dir}/${sample}.2.fq.gz \
    --out1 ${dir}/${sample}.step1.1.fq.gz --out2 ${dir}/${sample}.step1.2.fq.gz --report_title "${sample}" --html  ${sample}.html
```

## Step2: Reads Mapping
```bash
bwa aln -t 32  $refgenome  ${sample}.step1.1.fq.gz -f ${sample}_1.sai 
bwa aln -t 32  $refgenome  ${sample}.step1.2.fq.gz -f ${sample}_2.sai 
bwa sampe -r "@RG\tID:${sample}\tSM:${sample}\tPL:Illumina"  $refgenome ${sample}_1.sai	${sample}_2.sai	${sample}.step1.1.fq.gz	${sample}.step1.2.fq.gz  | samtools view -b   -q 20 -  | samtools sort   - > ${sample}.q20.sorted.bam
```

## Step3: MarkDuplicates and BQSR
```bash
gatk --java-options "-Xmx10g"  MarkDuplicates  \
    --tmp-dir ${dir}        \
    --INPUT  ${sample}.q20.sorted.bam   \
    --METRICS_FILE ${sample}.markdup_metrics.txt   \
    --OUTPUT ${sample}.sorted.markdup.bam
samtools index -@ ${nThreads} ${sample}.sorted.markdup.bam

gatk IndexFeatureFile  --input hapmap3-b73v4-201107.bed
gatk --java-options "-Xmx10g"  BaseRecalibrator \
    -R ${refgenome} \
    -I ${sample}.sorted.markdup.bam \
    --known-sites hapmap3-b73v4-201107.bed \
    -O ${sample}.sorted.markdup.recal_data.table

gatk --java-options "-Xmx10g"  ApplyBQSR \
    --bqsr-recal-file ${sample}.sorted.markdup.recal_data.table \
    -R ${refgenome} \
    -I ${sample}.sorted.markdup.bam \
    -O ${sample}.sorted.markdup.BQSR.bam 
samtools index -@ ${nThreads} ${dir}/${sample}.sorted.markdup.BQSR.bam 
```

## Step4: Gvcf calling
```bash
    sample=your_sample
output=your_gvcf
fa=$3
chr=$4
Input=${sample}.sorted.markdup.BQSR.bam
gatk HaplotypeCaller \
    --emit-ref-confidence GVCF \
    --reference ${refgenome} \
    --intervals ${chr} \
    --input ${input} \
    --output ${output}
```

## Step5: Generation of population-level VCF
```bash
#ImportDB
gatk GenomicsDBImport -R ${refgenome} --sample-name-map gvcf.chr1.map --genomicsdb-workspace-path genomeDB_chr1 -L 1 --reader-threads 40 --batch-size 500 --tmp-dir ./temp/genomeDB_chr1 1>chr1.GenomicsDBImport.log 2>&1
#GenotypeGVCFs
java  -jar $GATK  GenotypeGVCFs -R $REF --variant   gendb://../01GDB/genomeDB_chr1 --intervals 1:1-4020000 -O 1:1-4020000.raw.vcf.gz 1> 1:1-4020000.GenotypeGVCFs.log 2>&1 
```
