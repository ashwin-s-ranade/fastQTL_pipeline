#!/bin/bash
#$ -V
#$ -cwd

snakemake -j 99 --cluster "qsub -l h_rt=0:30:00,h_data=5G -cwd -V "
