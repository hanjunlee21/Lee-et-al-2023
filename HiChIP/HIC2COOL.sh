#!/bin/bash

fastq="../fastq"
bam="../bam"
hic="../hic"
cool="../cool"
data="../data"
GENOME="/media/hanjun/Hanjun_Lee_Book/Genome"

files="WTCI KOCI"

extension="fq.gz"

conversion() {
printf "conversion ${1}\n"
hic2cool convert ${hic}/${1}.hic ${cool}/${1}.100kb.raw.cool -r 100000
cooler dump --join ${cool}/${1}.100kb.raw.cool | cooler load --format bg2 ${data}/hg38.chrom.sizes:100000 - ${cool}/${1}.100kb.cool
cooler zoomify --balance ${cool}/${1}.100kb.cool
cooler balance ${cool}/${1}.100kb.cool
rm ${cool}/${1}.100kb.raw.cool
cooler coarsen -k 10 -o ${cool}/${1}.1Mb.cool ${cool}/${1}.100kb.cool
cooler zoomify --balance ${cool}/${1}.1Mb.cool
cooler balance ${cool}/${1}.1Mb.cool
}

mkdir -p ${cool}

for file in ${files}
do
conversion "$file"
done
