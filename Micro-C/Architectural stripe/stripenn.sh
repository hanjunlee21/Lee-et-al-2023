#!/bin/bash

cool="../cool"
stripe="../stripe"

mkdir -p $stripe

for file in WTCI KOCI WTCIR KOCIR 0hr 24hrs 72hrs
do
#ICE-normalized
#stripenn compute --cool $cool/$file.10kb.mcool::resolutions/10000 --norm weight --out $stripe/$file -s
stripenn score --cool $cool/$file.10kb.mcool::resolutions/10000 --coord $stripe/Merged.bedpe --norm weight --out $stripe/$file/$file.Merged.scores.tsv
done
