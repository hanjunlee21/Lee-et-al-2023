#!/bin/bash

for file in 0hr 24hrs 72hrs WTCI KOCI WTCIR KOCIR
do
printf "$file\n"
cooler coarsen -k 10 -o ../cool/$file.1Mb.cool ../cool/$file.100kb.cool
cooler zoomify --balance ../cool/$file.1Mb.cool
done
