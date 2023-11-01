#!/bin/bash

plot="../HiCCUPS_Diff/plot"

#make_tracks_file --trackFiles ../hdf5/WTCI.5kb.h5 ../hdf5/KOCI.5kb.h5 ../bigwig/CTCF.bw ../bigwig/SMC3.WTCI.bw ../bigwig/SMC3.KOCI.bw ../bigwig/SMC3.WTCI.scaled.bw ../bigwig/SMC3.KOCI.scaled.bw ../bigwig/WTCI.100kb.bw ../bigwig/KOCI.100kb.bw -o $plot/cohesin_WTCI_vs_KOCI.ini

pyGenomeTracks --tracks $plot/cohesin_WTCI_vs_KOCI.ini --region chr11:29845000-31360000 --outFileName $plot/cohesin_WTCI_vs_KOCI_chr11.pdf --dpi 1200
pyGenomeTracks --tracks $plot/cohesin_WTCI_vs_KOCI.ini --region chr9:30615000-32305000 --outFileName $plot/cohesin_WTCI_vs_KOCI_chr9.pdf --dpi 1200
