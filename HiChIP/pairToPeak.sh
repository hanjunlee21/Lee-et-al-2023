#!/bin/bash

bed="../bed"
pair="../pair"
loop="../loop"

thres="100000"

mkdir -p ${pair}/H3K27ac

task() {
awk '{printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t.\t%s\t%s\n", $2,$3,$3+1,$5,$6,$6+1,$1,$4,$7}' ${pair}/${1}/${1}.allValidPairs > ${pair}/${1}.validPairs.bedpe
pairToBed -type both -a ${pair}/${1}.validPairs.bedpe -b ${bed}/H3K27ac.bed > ${pair}/H3K27ac/${1}.H3K27ac.validPairs.bedpe
pairToBed -type both -a ${pair}/H3K27ac/${1}.H3K27ac.validPairs.bedpe -b ${bed}/H3K27ac.Enhancer.bed > ${pair}/H3K27ac/${1}.H3K27ac.EE.validPairs.bedpe
pairToBed -type xor -a ${pair}/H3K27ac/${1}.H3K27ac.validPairs.bedpe -b ${bed}/H3K27ac.Enhancer.bed > ${pair}/H3K27ac/${1}.H3K27ac.EP.validPairs.bedpe
pairToBed -type both -a ${pair}/H3K27ac/${1}.H3K27ac.validPairs.bedpe -b ${bed}/H3K27ac.Promoter.bed > ${pair}/H3K27ac/${1}.H3K27ac.PP.validPairs.bedpe
}

for file in WTCI KOCI
do
task "${file}" &
done
printf "Running...\n"
wait
printf "Completed\n"
