#!/bin/bash
# conda activate /home/hanjun/HiC-Pro/env before this script

fastq="../fastq"
bam="../bam"
hic="../hic"
cool="../cool"
data="../data"
pair="../pair"
loop="../loop"
hicpro="../hicpro"
diffloop="../diffloop"
chipseq="../ChIP-seq"
GENOME="/media/hanjun/Hanjun_Lee_Book/Genome"
pipeline="/media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/HiChIP/pipeline"

files="WTCI KOCI"

extension="fq.gz"

mkdir -p ${diffloop}

printf "differential_loop\n"
Rscript $HOME/FitHiChIP/Imp_Scripts/DiffAnalysisHiChIP.r --AllLoopList ${loop}/WTCI/FitHiChIP_Peak2ALL_b100000_L200000_U10000000/P2PBckgr_0/Coverage_Bias/FitHiC_BiasCorr/WTCI_100kb.interactions_FitHiC.bed,${loop}/KOCI/FitHiChIP_Peak2ALL_b100000_L200000_U10000000/P2PBckgr_0/Coverage_Bias/FitHiC_BiasCorr/KOCI_100kb.interactions_FitHiC.bed --ChrSizeFile ${GENOME}/hg38.chromosomal.XYM.genome --FDRThr 0.01 --CovThr 25 --ChIPAlignFileList ${chipseq}/WTCI.bam,${chipseq}/KOCI.bam --OutDir ${diffloop} --CategoryList WTCI,KOCI --ReplicaCount 1,1 --ReplicaLabels1 R1 --ReplicaLabels2 R1 --FoldChangeThr 2 --DiffFDRThr 0.05 --bcv 0.4
