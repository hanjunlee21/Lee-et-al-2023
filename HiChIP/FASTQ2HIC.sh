#!/bin/bash

fastq="../fastq"
bam="../bam"
hic="../hic"
cool="../cool"
data="../data"
GENOME="/media/hanjun/Hanjun_Lee_Book/Genome"

files="WTCI KOCI"

extension="fq.gz"

fastq2bam() {
printf "fastq2bam ${1}\n"
mkdir -p ${bam}/tmp/${1}
bwa mem -5SP -T0 -t8 ${GENOME}/hg38.chromosomal.XYM.fa ${fastq}/${1}_R1.${extension} ${fastq}/${1}_R2.${extension} | pairtools parse --min-mapq 40 --walks-policy 5unique --max-inter-align-gap 30 --nproc-in 8 --nproc-out 8 --chroms-path ${GENOME}/hg38.chromosomal.XYM.genome | pairtools sort --tmpdir=${bam}/tmp/${1} --nproc 8 | pairtools dedup --nproc-in 8 --nproc-out 8 --mark-dups --output-stats ${bam}/${1}.pairtools.stat.txt | pairtools split --nproc-in 8 --nproc-out 8 --output-pairs ${bam}/${1}.pairs --output-sam - | samtools view -bS -@8 | samtools sort -@8 -o ${bam}/${1}.bam
samtools index ${bam}/${1}.bam
}

mkdir -p ${bam} ${bam}/tmp

for file in ${files}
do
fastq2bam "$file"
done

juicer() {
printf "jucier ${1}\n"
java -Xmx48000m -Djava.awt.headless=true -jar ${HOME}/juicer/juicer_tools_1.22.01.jar pre --threads 8 ${bam}/${1}.valid.pairs ${hic}/${1}.hic ${GENOME}/hg38.chromosomal.XYM.genome
}

mkdir -p ${hic}

for file in ${files}
do
juicer "$file"
done

validpairs() {
printf "validpairs ${1}\n"
grep -v '#' ${bam}/${1}.pairs | awk -F "\t" '{print $1"\t"$2"\t"$3"\t"$6"\t"$4"\t"$5"\t"$7}' > ${bam}/${1}.valid.pairs
}

for file in ${files}
do
validpairs "$file"
done

hic2cool() {
printf "hic2cool ${1}\n"
hic2cool convert ${hic}/${1}.hic ${cool}/${1}.10kb.raw.cool -r 10000
cooler dump --join ${cool}/${1}.10kb.raw.cool | cooler load --format bg2 ${data}/hg38.chrom.sizes:10000 - ${cool}/${1}.10kb.cool
cooler zoomify --balance ${cool}/${1}.10kb.cool
cooler balance ${cool}/${1}.10kb.cool
rm ${cool}/${1}.10kb.raw.cool
cooler coarsen -k 100 -o ${cool}/${1}.1Mb.cool ${cool}/${1}.10kb.cool
cooler zoomify --balance ${cool}/${1}.1Mb.cool
cooler balance ${cool}/${1}.1Mb.cool
}

mkdir -p ${cool}

for file in ${files}
do
hic2cool "$file"
done
