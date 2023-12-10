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
GENOME="/media/hanjun/Hanjun_Lee_Book/Genome"
pipeline="/media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/HiChIP/pipeline"

files="WTCI KOCI"

extension="fq.gz"

mkdir -p ${loop}

loop() {
printf "loop ${1}\n"
sed 's/toReplace/'${1}'/g' config > ${1}_config
bash $HOME/FitHiChIP/./FitHiChIP_HiCPro.sh -C ${1}_config
rm ${1}_config
}

for file in ${files}
do
loop "$file"
done
