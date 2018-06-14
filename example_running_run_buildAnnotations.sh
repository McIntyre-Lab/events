#!/bin/sh

## Example shell script to build Event Analysis annotations

# Variables to set

## Path to Event Analysis install
EVENTDIR=/path/to/event_analysis

## Label to prefix to annotation files (e.g. mm10_refseq, dmel617, hg38_ens)
PREFIX=mm10

## Path to formatted GFF3 file (should in a FlyBase GFF3 format)
GFF=/path/to/mm10.gff 

## Path to genome FASTA
FASTA=/path/to/mm10.fa

## Size (in nt) of reads
READSIZE=56

## Output directory. If it does not exist, the annotation build script with create it
OUTDIR=/path/to/my_analysis/annotations

# Build Event Analysis annotations
cd ${EVENTDIR}
sh ./run_buildAnnotations.sh ${PREFIX} ${GFF} ${FASTA} ${READSIZE} ${OUTDIR}


