#!/bin/sh

## Example shell script to convert GTF/GFF to Flybase-style GFF3

# Variables to set

## Path to Event Analysis install. This is the folder containing "docs", "src", run_buildAnnotations.sh, etc.
EVENTDIR=/path/to/event_analysis

## Path to GTF/GFF file to convert
GFF=/path/to/mygtf.gtf

## Output GFF path and name. Make sure this ends with ".gff"
GFFOUT=/path/to/mygff3.converted.gff

SCRIPTS=${EVENTDIR}/src

## 

# Checking if a gff.db file exists, and if not then create one
echo "Checking if user-supplied GTF/GFF file has a pre-generated database file"
    if [ ! -e ${GFF}.db ]
    then
    echo "No database file found! Generating..."
    python $SCRIPTS/make_gff_db.py --gff $GFF
    echo "Database generated!"
    else
    echo "Database file found! Skipping generation."
    fi

# Convert user-supplied GTF/GFF file into GFF3 format
echo "Converting user-supplied GTF/GFF to GFF3 format"

python $SCRIPTS/convertGTF2GFF3.py --input $GFF --output ${GFFOUT}

sort -k1,1 -k4n -k5n ${GFFOUT} > ${TMPDIR}/temp.gff
mv ${TMPDIR}/temp.gff ${GFFOUT}

python $SCRIPTS/make_gff_db.py --gff ${GFFOUT}

