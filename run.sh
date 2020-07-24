#!/bin/bash
#$ -V
#$ -cwd

snakemake -j 99 --cluster "qsub -l h_rt=2:00:00,h_data=8G -cwd -V "
mail -s "snakemake finished" asr123@ucla.edu
