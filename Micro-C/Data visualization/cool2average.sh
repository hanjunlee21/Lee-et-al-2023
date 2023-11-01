#!/bin/bash
cool="/media/hanjun/Hanjun_Lee_Book/Lawrence/Micro-C/Processed/cool"
hic="/media/hanjun/Hanjun_Lee_Book/Lawrence/Micro-C/Processed/hic"
bed="/media/hanjun/Hanjun_Lee_Book/Lawrence/SMC3/ChIP/bed"
cool2="/media/hanjun/Hanjun_Lee_Book/Lawrence/SMC3/ChIP/cool"

task() {
hicAverageRegions --matrix $cool/$1.$2.cool --regions $bed/$3.bed --range 1000000 1000000 --outFileName $cool2/$1.$2.$3.npz --coordinatesToBinMapping center --considerStrandDirection
hicPlotAverageRegions --matrix $cool2/$1.$2.$3.npz --outputFile $cool2/$1.$2.$3.png --vMin $4 --vMax $5 --dpi 600 --colorMap Reds --log
}

for file in WTCI
do
task "$file" "5kb" "Promoter.RB.chromosomal" "0.1" "10"
task "$file" "5kb" "Promoter.nonRB.chromosomal" "0.1" "10"
task "$file" "5kb" "Insulator.RB.motif.chromosomal" "0.1" "10"
task "$file" "5kb" "Insulator.nonRB.motif.chromosomal" "0.1" "10"
task "$file" "5kb" "Enhancer.RB.chromosomal" "0.1" "10"
task "$file" "5kb" "Enhancer.nonRB.chromosomal" "0.1" "10"
task "$file" "5kb" "Promoter.CTRL.RB.chromosomal" "0.1" "10"
task "$file" "5kb" "Promoter.CTRL.nonRB.chromosomal" "0.1" "10"
done

