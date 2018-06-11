#!/bin/sh

## Example shell script to use Event Analysis to identify likely transcripts

# Variables to set

## Path to Event Analysis install
EVENTDIR=/path/to/event_analysis

## Project name (avoid using spaces)
PROJNAME=my_example

## Path to directory of your Event Analysis annotations files
ANNOTDIR=/path/to/my_analysis/annotations

## Annotation prefix you used to build your annotation files
ANNOTPREFIX=mm10

## Path to tab-delimited design file to relate samples to condition
DESIGN=/path/to/my_analysis/design_file.tsv

## Variable (as spelled in your design file) with which to group samples
GROUPVAR=cell_type

## Path to directory of exon fragment coverage counts
FRAGCOUNTS=/path/to/my_analysis/fragment_counts

## Path to directory of exonic region coverage counts
FUSCOUNTS=/path/to/my_analysis/region_counts

## Path to directory of intron coverage counts
INTCOUNTS=/path/to/my_analysis/intron_counts

## Path to directory of junction coverage counts
JUNCCOUNTS=/path/to/my_analysis/junction_counts

## Minimum APN (or other abundance measurement) for an event to be considered detected 
MINAPN=0

## Minimum proportion of samples per group were event is detected for event to be
## considered detected per group (range: 0 - 1, e.g. 0.5)
MINDTCT=

## Minimum length (in nucleotides) of an event for the event to be informative
EVENTLEN=10

## Read of RNAseq reads in nucleotides
READSIZE=56

## Minimum APN (or other abundance measurement) for a border junction to be considered
## supportive of a novel donor site
MINDONOR=5

## Minimum APN (or other abundance measurement) for a border junction to be considered
## supportive of a novel acceptor site
MINACCEPTOR=5

## Minimum APN (or other abundance measurement) for an intron to be considered
## supported/likely retained
MININTRON=5

## Output directory. If it does not exist, the annotation build script with create it
OUTDIR=/path/to/my_analysis/output

# Run Event Analysis to identify likely transcripts
cd ${EVENTDIR}
sh ./run_identifyTranscriptome.sh ${PROJNAME} ${ANNOTDIR} ${ANNOTPREFIX} \
                                  ${DESIGN} ${GROUPVAR} ${FRAGCOUNTS} \
                                  ${FUSCOUNTS} ${INTCOUNTS} ${JUNCCOUNTS} \
                                  ${MINAPN} ${MINDTCT} ${EVENTLEN} ${READSIZE} \
                                  ${MINDONOR} ${MINACCEPTOR} ${MININTRON} \
                                  ${OUTDIR}
