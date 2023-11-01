#!/bin/bash

mkdir -p ../output/pdb

for file in 0hr 24hrs 72hrs WTCI KOCI WTCIR KOCIR
do
for idx in $(seq 0 1 99)
do
python2 $HOME/pgs/tools/hms_export.py ../output/$file/structure/copy$idx.hms 0.01 ../output/pdb/$file.$idx.pdb
printf "$file, $idx\n"
done
done
