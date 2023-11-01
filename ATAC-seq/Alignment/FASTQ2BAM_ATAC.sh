#!/bin/bash

indir="../ATAC/fastq"
outdir="../ATAC/bam"
bwdir="../ATAC/bigwig"
files="RS-03915884_1-RPEWT-CI-PL-20220916_S1 RS-03915885_2-RPEKO-CI-PL-20220916_S2 RS-03915886_3-RPEWT-CIR-PL-20220916_S3 RS-03915887_4-RPEKO-CIR-PL-20220916_S4 RS-03915888_5-RPE11FDCDK-0H-PL-20220916_S5 RS-03915889_6-RPE11FDCDK-24H-PL-20220916_S6 RS-03915890_7-RPE11FDCDK-72H-20220916_S7"
extension="fq.gz"
GENOME="/media/hanjun/Hanjun_Lee_Book/Genome"
hg38="../ChIP/bed/hg38"
bedgraph="../ATAC/bedgraph"
trimgalore="../ATAC/trim_galore"

mkdir -p $outdir $bwdir $trimgalore $bedgraph

for file in $files
do
trim_galore --illumina --fastqc --paired -j 8 -o $trimgalore/$file $indir/${file}_R1_001.$extension $indir/${file}_R2_001.$extension
done

for file in $files
do
bwa mem -t 8 $GENOME/hg38.chromosomal.XYM.fa $trimgalore/${file}/${file}_R1_001_val_1.$extension $trimgalore/${file}/${file}_R2_001_val_2.$extension | samtools sort -@ 8 -o $outdir/$file.samtools.bam -
samtools index -@ 8 $outdir/$file.samtools.bam
sambamba sort -p -t 8 -o $outdir/$file.sambamba.bam $outdir/$file.samtools.bam
sambamba markdup -p -r -t 8 $outdir/$file.sambamba.bam $outdir/$file.bam
sambamba index -p -t 8 $outdir/$file.bam
echo $file
done

for file in $files
do
sambamba view -F "not (duplicate) and [NM] <= 2 and mapping_quality >= 30" -f bam -t 8 -o $outdir/$file.filtered.bam $outdir/$file.bam
sambamba index -p -t 8 $outdir/$file.filtered.bam
bamCoverage -b $outdir/$file.filtered.bam --normalizeUsing CPM --outFileFormat bigwig --binSize 1 -o $bwdir/$file.CPM.bigWig
done

for file in $files
do
printf "${file}: "
for chr in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y
do
printf "${chr}, "
samtools view -b $outdir/$file.filtered.bam chr${chr} > $outdir/$file.filtered.$chr.bam
samtools index $outdir/$file.filtered.$chr.bam
bedtools coverage -a $hg38/chr$chr.bed -b $outdir/$file.filtered.$chr.bam | awk '{if($1!~/chr/) {printf "chr"; print $0} else {print $0}}' > $bedgraph/$file.$chr.bedgraph
rm $outdir/$file.filtered.$chr.bam $outdir/$file.filtered.$chr.bam.bai
done
cat $bedgraph/$file.1.bedgraph $bedgraph/$file.2.bedgraph $bedgraph/$file.3.bedgraph $bedgraph/$file.4.bedgraph $bedgraph/$file.5.bedgraph $bedgraph/$file.6.bedgraph $bedgraph/$file.7.bedgraph $bedgraph/$file.8.bedgraph $bedgraph/$file.9.bedgraph $bedgraph/$file.10.bedgraph $bedgraph/$file.11.bedgraph $bedgraph/$file.12.bedgraph $bedgraph/$file.13.bedgraph $bedgraph/$file.14.bedgraph $bedgraph/$file.15.bedgraph $bedgraph/$file.16.bedgraph $bedgraph/$file.17.bedgraph $bedgraph/$file.18.bedgraph $bedgraph/$file.19.bedgraph $bedgraph/$file.20.bedgraph $bedgraph/$file.21.bedgraph $bedgraph/$file.22.bedgraph $bedgraph/$file.X.bedgraph $bedgraph/$file.Y.bedgraph > $bedgraph/$file.bedgraph
rm $bedgraph/$file.1.bedgraph $bedgraph/$file.2.bedgraph $bedgraph/$file.3.bedgraph $bedgraph/$file.4.bedgraph $bedgraph/$file.5.bedgraph $bedgraph/$file.6.bedgraph $bedgraph/$file.7.bedgraph $bedgraph/$file.8.bedgraph $bedgraph/$file.9.bedgraph $bedgraph/$file.10.bedgraph $bedgraph/$file.11.bedgraph $bedgraph/$file.12.bedgraph $bedgraph/$file.13.bedgraph $bedgraph/$file.14.bedgraph $bedgraph/$file.15.bedgraph $bedgraph/$file.16.bedgraph $bedgraph/$file.17.bedgraph $bedgraph/$file.18.bedgraph $bedgraph/$file.19.bedgraph $bedgraph/$file.20.bedgraph $bedgraph/$file.21.bedgraph $bedgraph/$file.22.bedgraph $bedgraph/$file.X.bedgraph $bedgraph/$file.Y.bedgraph
printf "done\n"
done
