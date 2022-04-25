# Event Analysis v1.0.17
Event Analysis is an annotation-driven, transcriptional event-based method for transcriptome reference reduction by using the detection and quantification of transcriptonal events (junctions, exons, exon fragments) to identify what transcripts are likely present and which are likely not present given experimental data.

It comprises of a collection of python scripts and example shell submission scripts for Event Analysis. Details on the approach and benchmarking against other methods can be found in the G3:Genomics manuscript (Newman et al, 2018, "Event Analysis : using transcript events to improve estimates of abundance in RNA-seq data", G3: Genes, Genomes, Genetics; http://www.g3journal.org/content/8/9/2923).

## Citing Event Analysis
To cite Event Analysis:
Newman, JRB, Concannon P, Tardaguila M, Conesa A, McIntyre LM, (2018) "Event Analysis: Using Transcript Events To Improve Estimates of Abundance in RNA-seq Data",
G3: Genes, Genomes, Genetics. v8(9), p2923-2940, https://doi.org/10.1534/g3.118.200373 

## Installation instructions

Installation requirements:

Event Analysis requires the following external python modules:
    * pandas (0.23.1)
    * pybedtools (0.7.10)
    * numpy (1.14.3)
    * gffutils (0.9)

### Installing dependencies

#### Installing dependencies using Anaconda:
NOTE: It is highly recommended you create a new conda environment, as this ensures that you are running/install the correct version of Python and dependencies. To do this, run the command:

    `conda create --name event_analysis python=3.6`

Then activate this environment:

    `conda activate event_analysis`

To install these dependencies via Anaconda run the following:

First, add the bioconda and conda-forge repositories using the commands:
    `conda config --add channels conda-forge`
    `conda config --add channels bioconda`

Then, to install the dependencies:
    `conda install -c jrbnewman event-analysis`

#### Installing dependencies manually

You can also install the required python modules manually using pip or conda install. Consult installation instructions for pip/conda install for the packages listed above

### Installing the Event Analysis suite

Create and navigate to the path where you would like to install Event Analysis. For example, if you wanted to create an install in your home directory:

    `mkdir -p $HOME/event_analysis`
    `cd $HOME/event_analysis`

Next, clone the git repository for Event Analysis using the command:

    `git clone https://github.com/McIntyre-Lab/events`

This will create a local copy of the most recent version of Event Analysis in your specified installation folder. If you prefer not to clone the git repository, you can also obtain the code using:

    `curl -sL https://github.com/McIntyre-Lab/events/archive/v1.0.16.tar.gz | tar xz`

This will also unpack the tarball into your Event Analysis install directory.

## Running Event Analysis

Event Analysis can be run either as each individual python script (see event_analysis/src) or  one of the shell scripts under the event_analysis folder (run_buildAnnotations.sh, run_identifyTranscriptome.sh). Two example scripts on how to invoke these shell scripts are also provided in the install directory (example_running_run_buildAnnotations.sh, example_running_run_identifyTranscriptome.sh).

See the README file *event_analysis_workflow_readme.docx* for more information.

## Example data and output

Simulated data and output that was used in the preparing of the manuscript and evelopment of Event Analysis is also available.

## CHANGELOG: 

## v1.0.16 -> v1.0.17
* Updated extractTranscriptJunctions.py to be compatible with later versions of GFFutils
* Missing hard version requirement for python dependencies added to conda environment recipe

## v1.0.14 -> v1.0.16

* Added citation and URL of the G3 manuscript.

### Bug fixes:
* Fixes a minor error when extracting annotated junctions when attempting to reopen the output file for writing.
* Fixes a minor bug in the run_buildAnnotations.sh script.


## v1.0.13e -> v.1.0.14
### Bug fixes:

* Fixed a bug in convertGTF2GFF3.py that caused the final chromosome entry to not write to the output GFF3 file. This occurs when a gene in the input GTF/GFF file has no valid exons listed. Now if at least one exon cannot be found for a given gene, a warning message will print to the console ("Gene [gene_id] has no valid exons and will be skipped."). This notably occurs with some versions of FlyBase GFF files that contain gene entries for miRNAs, but no corresponding exon entries.

### Changes:

* Also added to convertGTF2GFF3.py is a chromosome check. If a chromosome (or contig, scaffold, golden_path_region, etc.) has no valid exons (or no genes), it will not be written to the output GFF3 file. Previously, there was no message or indication that a featureless chromosome was skipped. Now the list of chromosomes/contigs/scaffolds/etc. are written to an output file (output GFF filename, appended with ".skipped_chrom"). If the script cannot determine the list of chromosomes in the input GTF/GFF file (for example, there is no entry for "chromosome", "chromosome_arm", or "golden_path_region") then the chromosome check is skipped and no list of skipped chromosomes is written. Users should validate that any chromsomes skipped in the output GFF3 are due to the absence of valid exon entries in the input GTF/GFF file.

## v1.0.13c -> v1.0.13e
### Bug fixes:

* Fixed a bug in the buildFusions.py script that throws a ValueError exception when building fusions/exonic regions for chromosomes with a single exon. This appears to affect FlyBase dmel/6.17 and dsim/2.02 GFF annotations

### Changes:

* Updated the make_gff_db.py script. If the db file already exists then the existing file is deleted and recreated.

* Updated conda recipe: specific version requirements added for NumPy (v1.14.3) and GFFutils (v0.9). Version requirements for pybedtools (v.0.7.10) and Pandas (v.0.23.1) have also been set to specific versions, instead of minimum version number. This is to ensure compatibility across all installs of Event Analysis.

