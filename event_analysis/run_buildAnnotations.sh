#!/bin/sh
###############################################################################
# Run Event Analysis - Build Annotations
# This is an example bash script to build annotation used by Event Analysis
#
# Usage:
# Running in home directory for Event Anaylsis
# sh ./run_buildAnnotations.sh ${PREFIX} ${GFF} ${FASTA} ${READSIZE} ${OUTDIR}
#
# PREFIX   : Prefix to append to created annotation files. This may be a 
#            project identifier, genome build, etc. This appended to the name
#            of each output file
# GFF      : Path to formatted GFF3 file. This should follow the format used
#            by FlyBase. If you are unsure, use the included script
#            "convertGTF2GFF3.py" to get it into this format
# FASTA    : Path to multi-sequence genome FASTA. Note that the chromosome
#            names MUST MATCH those in the GFF file
# READSIZE : Maximum size of RNA-seq reads. For PE reads, this is the size of
#            each read pair
# OUTDIR   : Output directory. This will be created if it does not exist
#
###############################################################################

## Parse command line arguments
PREFIX=${1}
GFF=${2}
FASTA=${3}
READSIZE=${4}
OUTDIR=${5}

## Set paths
SCRIPTS=$(pwd)/src

if [ ! -e ${OUTDIR} ]; then mkdir -p ${OUTDIR}; fi

## Build annotations
### (1) EXTRACT EVENTS
# Extract exons
echo "Extracting exons"
python $SCRIPTS/extractExons.py --gff ${GFF} --obed $OUTDIR/${PREFIX}_exons.bed --otable $OUTDIR/${PREFIX}_exons.csv

# Extract fusions (exonic regions)
echo "Extracting fusions"
python $SCRIPTS/buildFusions.py --gff ${GFF} --obed $OUTDIR/${PREFIX}_fusions.bed --otable $OUTDIR/${PREFIX}_fusions.tsv

# Extract exon fragments
echo "Extracting exon fragments"
python $SCRIPTS/extractExonFragments.py --gff ${GFF} --output $OUTDIR/${PREFIX}_exon_fragments.csv

# Build unambiguous introns from fusions
echo "Building unambiguous introns"
python $SCRIPTS/build_unambiguous_introns_from_fusions.py --input-fusion-file $OUTDIR/${PREFIX}_fusions.tsv \
                                                                --input-fusion-bed $OUTDIR/${PREFIX}_fusions.bed \
                                                                --outCSV $OUTDIR/${PREFIX}_introns_from_fusions.csv \
                                                                --outBED $OUTDIR/${PREFIX}_introns_from_fusions.bed

# Extract logical junctions
echo "Extracting logical junctions"
python $SCRIPTS/extractJunctions.py --input ${GFF}.db --output $OUTDIR/${PREFIX}_logical_junctions.bed --size 40

# Extract junctions annotated to transcripts
echo "Extracting annotated junctions"
python $SCRIPTS/extractTranscriptJunctions.py --gff ${GFF} --output $OUTDIR/${PREFIX}_annotated_junctions.csv

# Extract exon-skipping junction annotations
echo "Extracting exon-skipping annotations"
python $SCRIPTS/extractSkippedExons.py --gff ${GFF} --otable $OUTDIR/${PREFIX}_exonskipping_junctions.csv \
#                                                --olist $OUTDIR/${PREFIX}_skipped_exons_list.csv

# Build donor-site exon-intron border junctions
echo "Building donor-site exon-intron border junctions"
python $SCRIPTS/build_donor_border_junctions.py --gff ${GFF} --obed $OUTDIR/${PREFIX}_donor_border_junctions.bed \
                                       --otable $OUTDIR/${PREFIX}_donor_border_junctions.csv --size 40

# Build acceptor-site exon-intron border junctions
echo "Building acceptor-site exon-intron border junctions"
python $SCRIPTS/build_acceptor_border_junctions.py --gff ${GFF} \
                                       --obed $OUTDIR/${PREFIX}_acceptor_border_junctions.bed \
                                       --otable $OUTDIR/${PREFIX}_acceptor_border_junctions.csv --size 40

### (2) EXON ANNOTATIONS
# Format exon annotations
echo "Format exon annotations"
python $SCRIPTS/import_and_format_exons.py --input $OUTDIR/${PREFIX}_exons.csv --output $OUTDIR/${PREFIX}_exon_annotations.csv

# Format fusion (exonic region) annotations
echo "Format fusion annotations"
python $SCRIPTS/import_and_format_fusions.py --input-fusion-file $OUTDIR/${PREFIX}_fusions.tsv \
                                    --input-fusion-bed $OUTDIR/${PREFIX}_fusions.bed \
                                    --input-exon-file $OUTDIR/${PREFIX}_exons.csv \
                                    --outCSV $OUTDIR/${PREFIX}_fusion_annotations.csv \
                                    --outBED $OUTDIR/${PREFIX}_fusions_coverage.bed

# Format exon fragment annotations
echo "Format exon fragment annotations"
python $SCRIPTS/import_and_format_fragments.py --input-fragment-file $OUTDIR/${PREFIX}_exon_fragments.csv \
                                      --input-fusion-file $OUTDIR/${PREFIX}_fusions.tsv \
                                      --input-fusion-bed $OUTDIR/${PREFIX}_fusions.bed \
                                      --input-exon-file $OUTDIR/${PREFIX}_exons.csv \
                                      --outCSV $OUTDIR/${PREFIX}_exon_fragment_annotations.csv \
                                      --outBED $OUTDIR/${PREFIX}_exon_fragments_coverage.bed

### (3) JUNCTION ANNOTATIONS
# Format logical junctions
echo "Format logical junctions"
python $SCRIPTS/import_and_format_junctions.py --bed $OUTDIR/${PREFIX}_logical_junctions.bed \
                                      --output $OUTDIR/${PREFIX}_logical_junctions_formatted.csv

# Flag annotated junctions
echo "Flag annotated junctions"
python $SCRIPTS/import_and_flag_transcript_junctions.py --input-junctions $OUTDIR/${PREFIX}_logical_junctions_formatted.csv \
                                               --input-annotated-junctions $OUTDIR/${PREFIX}_annotated_junctions.csv \
                                               --output $OUTDIR/${PREFIX}_logical_junctions_flag_annotated.csv

# Flag exon-skipping junctions
echo "Add exon-skipping annotations"
python $SCRIPTS/import_exon_skipping_annotations.py --input-junctions $OUTDIR/${PREFIX}_logical_junctions_flag_annotated.csv \
                                           --input-exonskip-annot $OUTDIR/${PREFIX}_exonskipping_junctions.csv \
                                           --output $OUTDIR/${PREFIX}_logical_junctions_flag_exonskip.csv

# Append border junctions
echo "Append border junctions"
python $SCRIPTS/append_border_junctions.py --input-junctions $OUTDIR/${PREFIX}_logical_junctions_flag_exonskip.csv \
                                  --input-donor-border-junctions $OUTDIR/${PREFIX}_donor_border_junctions.bed \
                                  --input-acceptor-border-junctions $OUTDIR/${PREFIX}_acceptor_border_junctions.bed \
                                  --junction-size 40 \
                                  --output $OUTDIR/${PREFIX}_logical_junctions_and_border_junctions.csv

# Add exon info to junctions
echo "Add exon information to junctions"
python $SCRIPTS/add_exon_info_to_junctions.py --input-junction-file $OUTDIR/${PREFIX}_logical_junctions_and_border_junctions.csv \
                                     --input-exon-file $OUTDIR/${PREFIX}_exon_annotations.csv \
                                     --output-junction-info $OUTDIR/${PREFIX}_junctions_w_exon_info.csv

# Collapse junctions with identical coordinates
echo "Collapse junctions with identical coordinates"
python $SCRIPTS/collapse_duplicate_junctions.py --input-junction-file $OUTDIR/${PREFIX}_junctions_w_exon_info.csv \
                                       --input-exon-annotation $OUTDIR/${PREFIX}_exons.csv \
                                       --output-collapsed-junctions $OUTDIR/${PREFIX}_junctions_full_annotation.csv




# Extract junction sequences
echo "Extracting junction sequences"
python $SCRIPTS/extract_junction_sequence.py --input-junction-file $OUTDIR/${PREFIX}_junctions_full_annotation.csv \
                                    --input-fasta-file ${FASTA} \
                                    --output-junction-annotation $OUTDIR/${PREFIX}_junction_annotations.csv \
                                    --output-junction-to-seq-index $OUTDIR/${PREFIX}_junction_to_sequence_index.csv \
                                    --output-junction-sequences $OUTDIR/${PREFIX}_junctions.fa \
                                    --output-coverage-bed $OUTDIR/${PREFIX}_junctions_coverage.bed

### (4) CREATE EVENT INDICES
# Make event-to-transcript-to-gene index
echo "Creating event-to-transcript-gene index"
python $SCRIPTS/build_Event2Transcript_index.py -e $OUTDIR/${PREFIX}_exons.csv \
                                       -f $OUTDIR/${PREFIX}_exon_fragment_annotations.csv \
                                       -j $OUTDIR/${PREFIX}_junction_annotations.csv \
                                       -o $OUTDIR/${PREFIX}_event2transcript2gene_index.csv

# Make intron-to-border junction index
echo "Creating intron-to-border-junction index"
python $SCRIPTS/build_intron2border_junction_index.py --intron-annotation-file $OUTDIR/${PREFIX}_introns_from_fusions.csv \
                                             --junction-annotation-file $OUTDIR/${PREFIX}_junction_annotations.csv \
                                             --output-intron-index $OUTDIR/${PREFIX}_intron2border_junction_index.csv

echo "Completed creating Event Analysis annotations!"

