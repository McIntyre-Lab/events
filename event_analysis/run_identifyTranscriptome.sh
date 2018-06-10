#!/bin/sh
###############################################################################
# Run Event Analysis - Identify transcriptome
# This is an example bash script to use the detection of individual events 
# (e.g. exon fragments, junctions) to remove unlikely transcripts. In this
# example script, all possible modifiable values are individually set on the
# command line.
#
# Usage:
# Running in home directory for Event Anaylsis
# sh ./run_identifyTranscriptome.sh ${PROJNAME} ${ANNOTDIR} ${ANNOTPREFIX} \
#                                   ${DESIGN} ${GROUPVAR} ${FRAGCOUNTS} \
#                                   ${FUSCOUNTS} ${INTCOUNTS} ${JUNCCOUNTS} \
#                                   ${MINAPN} ${MINDTCT} ${EVENTLEN} ${READSIZE} \
#                                   ${MINDONOR} ${MINACCEPTOR} ${MININTRON} \
#                                   ${OUTDIR}
#
# 
# PROJNAME    : Name of your project. Ideally, keep this short and do not sure 
#               spaces.
# ANNOTDIR    : Path to the directory containing the output annotation files 
#               from run_buildAnnotations.sh
# ANNOTPREFIX : Annotation prefix as used to build your annotation files
# DESIGN      : Path to your design file that relates samples to condition
# GROUPVAR    : Name of variable in the design file with which to group samples.
#               This should be identical to the appropriate variable name in the
#               design file
# FRAGCOUNTS  : Path to directory containing exon fragment coverage counts.
# FUSCOUNTS   : Path to directory containing exonic region coverage counts.
# INTCOUNTS   : Path to directory containing intron coverage counts.
# JUNCCOUNTS  : Path to directory containing junction coverage counts.
# MINAPN      : Minimum APN for an event to considered detected
# MINDTCT     : Minimum proportion of samples for an event to be considered
#               detected in each condition (Range: 0 - 1) 
# EVENTLEN    : Minimum length (in nt) for an event to be considered informative.
# READSIZE    : Maximum read size of RNAseq reads used in experiment
# MINDONOR    : Minimum group average APN for a border junction to be considered \
#               a possible donor site
# MINACCEPTOR : Minimum group average APN for a border junction to be considered \
#               a possible acceptor site
# MININTRON   : Minimum group average APN for an intron to be considered evidence
#               of intron retention
# OUTDIR      : Path to output directory of analysis
#
#############################################################################

## Parse command line arguments
PROJNAME=$1
ANNOTDIR=$2
ANNOTPREFIX=$3
DESIGN=$4
GROUPVAR=$5
FRAGCOUNTS=$5
FUSCOUNTS=$6
INTCOUNTS=$7
JUNCCOUNTS=$8
MINAPN=$9
MINDTCT=$10
EVENTLEN=$11
READSIZE=$12
MINDONOR=$13
MINACCEPTOR=$14
MININTRON=$15
OUTDIR=$16

## Set paths
SCRIPTS=$(pwd)/src

if [ ! -e ${OUTDIR} ]; then mkdir -p ${OUTDIR}; fi


### (1) Convert single-file coverage counts into a single wide dataset
echo "Creating wide coverage datasets"
# Fragments
python $SCRIPTS/import_counts_and_convert_to_wide.py --input-directory ${FRAGCOUNTS} \
                                            --output-wide ${OUTDIR}/${PROJNAME}_fragment_counts_wide.tsv

# Fusions (exonic regions)
python $SCRIPTS/import_counts_and_convert_to_wide.py --input-directory ${FUSCOUNTS} \
                                            --output-wide ${OUTDIR}/${PROJNAME}_fusion_counts_wide.tsv


# Introns
python $SCRIPTS/import_counts_and_convert_to_wide.py --input-directory ${INTCOUNTS} \
                                            --output-wide ${OUTDIR}/${PROJNAME}_intron_counts_wide.tsv

# Junctions
python $SCRIPTS/import_counts_and_convert_to_wide.py --input-directory ${JUNCCOUNTS} \
                                            --output-wide ${OUTDIR}/${PROJNAME}_junction_counts_wide.tsv


### (2) Flag events on/off
echo "Identifying detected events"

# Fragments
python $SCRIPTS/flag_event_detection.py --input-data ${OUTDIR}/${PROJNAME}_fragment_counts_wide.tsv \
                                              --design-file ${DESIGN} \
                                              --group-variable ${GROUPVAR} \
                                              --minimum-abundance ${MINAPN} \
                                              --minimum-proportion ${MINDTCT} \
                                              --output-flags ${OUTDIR}/${PROJNAME}_fragment_flagged_apn${MINAPN}.tsv

# Fusions (exonic regions)
python $SCRIPTS/flag_event_detection.py --input-data ${OUTDIR}/${PROJNAME}_fusion_counts_wide.tsv \
                                              --design-file ${DESIGN} \
                                              --group-variable ${GROUPVAR} \
                                              --minimum-abundance ${MINAPN} \
                                              --minimum-proportion ${MINDTCT} \
                                              --output-flags ${OUTDIR}/${PROJNAME}_fusion_flagged_apn${MINAPN}.tsv

# Introns
python $SCRIPTS/flag_event_detection.py --input-data ${OUTDIR}/${PROJNAME}_intron_counts_wide.tsv \
                                              --design-file ${DESIGN} \
                                              --group-variable ${GROUPVAR} \
                                              --minimum-abundance ${MINAPN} \
                                              --minimum-proportion ${MINDTCT} \
                                              --output-flags ${OUTDIR}/${PROJNAME}_intron_flagged_apn${MINAPN}.tsv

# Junctions
python $SCRIPTS/flag_event_detection.py --input-data ${OUTDIR}/${PROJNAME}_junction_counts_wide.tsv \
                                              --design-file ${DESIGN} \
                                              --group-variable ${GROUPVAR} \
                                              --minimum-abundance ${MINAPN} \
                                              --minimum-proportion ${MINDTCT} \
                                              --output-flags ${OUTDIR}/${PROJNAME}_junction_flagged_apn${MINAPN}.tsv

### (3) Create event-level summaries
echo "Creating event-level summaries"
# Fragments
python $SCRIPTS/create_event_summaries.py --input-data ${OUTDIR}/${PROJNAME}_fragment_counts_wide.tsv \
                                                --design-file ${DESIGN} \
                                                --event-length ${EVENTLEN} \
                                                --group-variable ${GROUPVAR} \
                                                --annotation-file ${ANNOTDIR}/${ANNOTPREFIX}_exon_fragment_annotations.csv \
                                                --detection-flags-file ${OUTDIR}/${PROJNAME}_fragment_flagged_apn${MINAPN}.tsv \
                                                --output-summary ${OUTDIR}/${PROJNAME}_summary_by_exon_fragment.tsv

# Fusions (exonic regions)
python $SCRIPTS/create_event_summaries.py --input-data ${OUTDIR}/${PROJNAME}_fusion_counts_wide.tsv \
                                                --design-file ${DESIGN} \
                                                --event-length ${EVENTLEN} \
                                                --group-variable ${GROUPVAR} \
                                                --annotation-file ${ANNOTDIR}/${ANNOTPREFIX}_fusion_annotations.csv \
                                                --detection-flags-file ${OUTDIR}/${PROJNAME}_fusion_flagged_apn${MINAPN}.tsv \
                                                --output-summary ${OUTDIR}/${PROJNAME}_summary_by_fusion.tsv


# Introns
python $SCRIPTS/create_event_summaries.py --input-data ${OUTDIR}/${PROJNAME}_intron_counts_wide.tsv \
                                                --design-file ${DESIGN} \
                                                --group-variable ${GROUPVAR} \
                                                --event-length ${EVENTLEN} \
                                                --annotation-file ${ANNOTDIR}/${ANNOTPREFIX}_introns_from_fusions.csv \
                                                --detection-flags-file ${OUTDIR}/${PROJNAME}_intron_flagged_apn${MINAPN}.tsv \
                                                --output-summary ${OUTDIR}/${PROJNAME}_summary_by_intron.tsv

# Junctions
python $SCRIPTS/create_event_summaries.py --input-data ${OUTDIR}/${PROJNAME}_junction_counts_wide.tsv \
                                                --design-file ${DESIGN} \
                                                --event-length ${READSIZE} \
                                                --group-variable ${GROUPVAR} \
                                                --junction-sequence-index ${ANNOTDIR}/${ANNOTPREFIX}_junction_to_sequence_index.csv \
                                                --annotation-file ${ANNOTDIR}/${ANNOTPREFIX}_junction_annotations.csv \
                                                --detection-flags-file ${OUTDIR}/${PROJNAME}_junction_flagged_apn${MINAPN}.tsv \
                                                --output-summary ${OUTDIR}/${PROJNAME}_summary_by_junction.tsv

### (4) Identify expressed genes in each group
echo "Identifying expressed genes"
python $SCRIPTS/identify_expressed_genes.py --input-exonic-region-summary ${OUTDIR}/${PROJNAME}_summary_by_fusion.tsv \
                                                  --design-file ${DESIGN} \
                                                  --group-variable ${GROUPVAR} \
                                                  --output-gene-summary ${OUTDIR}/${PROJNAME}_summary_of_expressed_genes.tsv

### (5) Create intron-border junction summaries
echo "Creating intron-to-border junction summaries"
python $SCRIPTS/create_intron_border_summary.py \
       --input-exonic-region-summary ${OUTDIR}/${PROJNAME}_summary_by_fusion.tsv \
       --input-intron-summary ${OUTDIR}/${PROJNAME}_summary_by_intron.tsv \
       --input-junction-summary ${OUTDIR}/${PROJNAME}_summary_by_junction.tsv \
       --intron-border-junction-index ${ANNOTDIR}/${ANNOTPREFIX}_intron2border_junction_index.csv \
       --design-file ${DESIGN} \
       --group-variable ${GROUPVAR} \
       --minimum-donor-mean ${MINDONOR} \
       --minimum-acceptor-mean ${MINACCEPTOR} \
       --minimum-intron-mean ${MININTRON} \
       --output-intron-border-summary ${OUTDIR}/${PROJNAME}_summary_of_intron_borderjunctions.tsv

### (6) Summarize transcripts
echo "Summarizing transcripts"
python $SCRIPTS/summarize_transcripts_by_group.py --input-gene-summary ${OUTDIR}/${PROJNAME}_summary_of_expressed_genes.tsv \
       --input-exon-fragment-summary ${OUTDIR}/${PROJNAME}_summary_by_exon_fragment.tsv \
       --input-junction-summary ${OUTDIR}/${PROJNAME}_summary_by_junction.tsv \
       --input-event-to-transcript-index ${ANNOTDIR}/${ANNOTPREFIX}_event2transcript2gene_index.csv \
       --design-file ${DESIGN} \
       --group-variable ${GROUPVAR} \
       --output-transcript-summary ${OUTDIR}/${PROJNAME}_summary_of_transcripts_exp_genes.tsv

