#!/bin/bash

task() {
printf "Running $1\n"

export PYTHONPATH="${PYTHONPATH}:/home/hanjun/pgs"
export PYTHONPATH="${PYTHONPATH}:/home/hanjun/pgs/alab"
export PYTHONPATH="${PYTHONPATH}:/home/hanjun/pgs/build"
export PYTHONPATH="${PYTHONPATH}:/home/hanjun/pgs/docs"
export PYTHONPATH="${PYTHONPATH}:/home/hanjun/pgs/pgsflows"
export PYTHONPATH="${PYTHONPATH}:/home/hanjun/pgs/tools"

mkdir -p /media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/loop/pgs/output/$1 /media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/loop/pgs/pyflow/$1
sed 's/fileNameToReplace/'$1'/g' /media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/loop/pgs/pipeline/input_config.json > /media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/loop/pgs/pipeline/input_config_$1.json
python2 /home/hanjun/pgs/pgs.py --input_config /media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/loop/pgs/pipeline/input_config_$1.json --run_mode local --nCores 8 --memMb 32000 --pyflow_dir /media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/loop/pgs/pyflow/$1
mv /media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/loop/pgs/pipeline/input_config_$1.json /media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/loop/pgs/output/$1/input_config_$1.json

printf "Completed $1\n"
}

mkdir -p /media/hanjun/Hanjun_Lee_Book/Lawrence/H3K27ac/loop/pgs/pyflow

for file in 0hr 24hrs 72hrs WTCI KOCI WTCIR KOCIR
do
task "$file" &
done
printf "Running\n"
wait
printf "Completed\n"
