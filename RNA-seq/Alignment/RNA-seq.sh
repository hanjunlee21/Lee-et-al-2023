#!/bin/bash
trimgalore="../Processed/RNA-seq/trim-galore"
aligned="../Processed/RNA-seq/STAR"
fused="../Processed/RNA-seq/STAR-Fusion"
counted="../Processed/RNA-seq/RSEM"
stargenome="/media/hanjun/Hanjun_Lee_Book/Genome/STAR/hg38.chromosomal.X"
GENOME="/media/hanjun/Hanjun_Lee_Book/Genome"
thread=4

# Trim-galore
mkdir -p $trimgalore

galore() {
mkdir -p $trimgalore/$2
trim_galore --illumina --paired -j $thread -o $trimgalore/$2 $1/$2_1.fq.gz $1/$2_2.fq.gz
}

for file in A1 A2 A3 B1 B2 B3 C1 C2 C3 D1 D2 D3
do
galore "../Processed/RNA-seq/raw_data/$file" "$file" &
done
printf "Trimming FASTQ files...\n"
wait

# First-pass STAR
firstpass() {
mkdir -p $aligned/$1.tmp
STAR --runThreadN $thread --genomeDir $stargenome --readFilesIn $trimgalore/$1/$1_1_val_1.fq.gz $trimgalore/$1/$1_2_val_2.fq.gz --readFilesCommand zcat --sjdbOverhang 149 --sjdbGTFfile $GENOME/ensembl.v105.hg38.gtf --outFileNamePrefix $aligned/$1.tmp/
mv $aligned/$1.tmp/SJ.out.tab $aligned/sjdb.first/$1.tab
rm -r $aligned/$1.tmp
}

mkdir -p $aligned/sjdb.first $aligned/sjdb.second
for file in A1 A2 A3 B1 B2 B3 C1 C2 C3 D1 D2 D3
do
firstpass "$file"
done
printf "First-pass STAR...\n"
wait

# Second-pass STAR
secondpass() {
mkdir -p $aligned/$1
STAR --runThreadN $thread --genomeDir $stargenome --readFilesIn $trimgalore/$1/$1_1_val_1.fq.gz $trimgalore/$1/$1_2_val_2.fq.gz --readFilesCommand zcat --sjdbOverhang 149 --sjdbGTFfile $GENOME/ensembl.v105.hg38.gtf --outFileNamePrefix $aligned/$1/ --sjdbFileChrStartEnd $aligned/sjdb.first/A1.tab $aligned/sjdb.first/A2.tab $aligned/sjdb.first/A3.tab $aligned/sjdb.first/B1.tab $aligned/sjdb.first/B2.tab $aligned/sjdb.first/B3.tab $aligned/sjdb.first/C1.tab $aligned/sjdb.first/C2.tab $aligned/sjdb.first/C3.tab $aligned/sjdb.first/D1.tab $aligned/sjdb.first/D2.tab $aligned/sjdb.first/D3.tab --quantMode TranscriptomeSAM --outSAMtype BAM Unsorted
cp $aligned/$1/SJ.out.tab $aligned/sjdb.second/$1.tab
}

for file in A1 A2 A3 B1 B2 B3 C1 C2 C3 D1 D2 D3
do
secondpass "$file"
done
printf "Second-pass STAR...\n"
wait

count() {
rsem-calculate-expression -p $thread --alignments --paired-end $aligned/$1/Aligned.toTranscriptome.out.bam $GENOME/RSEM/hg38.chromosomal.X $counted/$1
}

mkdir -p $counted

for file in A1 A2 A3 B1 B2 B3 C1 C2 C3 D1 D2 D3
do
count "$file" &
done
printf "RSEM...\n"
wait

# STAR-Fusion
fusion() {
mkdir -p $fused/$1
STAR-Fusion --left_fq $trimgalore/$1/$1_1_val_1.fq.gz --right_fq $trimgalore/$1/$1_2_val_2.fq.gz --genome_lib_dir $GENOME/STAR-Fusion/GRCh38.gencode.v37.CTAT --output_dir $fused/$1
}

for file in A1 A2 A3 B1 B2 B3 C1 C2 C3 D1 D2 D3
do
fusion "$file"
done
printf "STAR-Fusion...\n"
wait

bamsort() {
samtools sort -O bam $aligned/$1$2/Aligned.out.bam > $aligned/$1$2/Aligned.out.sorted.bam
samtools index $aligned/$1$2/Aligned.out.sorted.bam
}

tobigwig() {
for num in 1 2 3
do
bamsort "$1" "$num" &
done
printf "Sorting $1 BAM files...\n"
wait

samtools merge $aligned/$1.merged.bam $aligned/$1"1/Aligned.out.sorted.bam" $aligned/$1"2/Aligned.out.sorted.bam" $aligned/$1"3/Aligned.out.sorted.bam"
samtools index $aligned/$1.merged.bam
bamCoverage -b $aligned/$1.merged.bam -o $aligned/$1.hg38.bedGraph -of bedgraph
$HOME/ucsc/liftOver $aligned/$1.hg38.bedGraph /home/hanjun/ucsc/hg38ToHg19.over.chain $aligned/$1.hg19.unsorted.bedGraph $aligned/$1.hg19.unMapped
rm $aligned/$1.hg19.unMapped
LC_COLLATE=C sort -k1,1 -k2,2n $aligned/$1.hg19.unsorted.bedGraph > $aligned/$1.hg19.bedGraph
rm $aligned/$1.hg19.unsorted.bedGraph
cat $aligned/$1.hg19.bedGraph | awk 'BEGIN{OFS="\t"}{if (NR>1 && prev_chr==$1 && prev_chr_e<=$2) {print $0}; prev_chr=$1; prev_chr_e=$3;}' > $aligned/$1.hg19.noOverlap.bedGraph
$HOME/ucsc/bedGraphToBigWig $aligned/$1.hg19.noOverlap.bedGraph $GENOME/hg19.chrom.sizes $aligned/$1.hg19.bigWig
bamCoverage -b $aligned/$1.merged.bam --normalizeUsing CPM --outFileFormat bigwig --binSize 1 -o $aligned/$1.CPM.bigWig
}

for case in A B C D
do
tobigwig "$case" &
done
printf "BIGWIG...\n"
wait
