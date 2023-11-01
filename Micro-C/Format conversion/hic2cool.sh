#!/bin/bash

task() {
hic2cool convert ../../hic/$1.hic ../cool/$1.10kb.raw.cool -r 10000
cooler dump --join ../cool/$1.10kb.raw.cool | cooler load --format bg2 ../data/hg38.chrom.sizes:10000 - ../cool/$1.10kb.cool
cooler zoomify --balance ../cool/$1.10kb.cool
rm ../cool/$1.10kb.raw.cool
printf "$1: completed\n"
}

for file in 0hr 24hrs 72hrs WTCI KOCI WTCIR KOCIR
do
task "$file"
done
