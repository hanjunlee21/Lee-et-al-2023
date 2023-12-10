#!/bin/bash

fastq="../fastq"
bam="../bam"
hic="../hic"
cool="../cool"
data="../data"
bed="../bed"
chip="../ChIP-seq"
GENOME="/media/hanjun/Hanjun_Lee_Book/Genome"

files="WTCI"

extension="fq.gz"

mkdir -p ${bed} ${bed}/macs2

macs2 callpeak -t ${chip}/WTCI.bam ${chip}/WTCIR.bam ${chip}/KOCI.bam ${chip}/KOCIR.bam --outdir ${bed}/macs2
