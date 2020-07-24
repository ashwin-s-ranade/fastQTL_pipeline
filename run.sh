#!/bin/bash
#$ -V
#$ -cwd

snakemake -j 99 --cluster "qsub -l h_rt=1:30:00,h_data=5G -cwd -V" 2> snakemake.log
mail -s "snakemake finished" asr123@ucla.edu < snakemake.log
