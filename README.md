# Event Analysis v1.0.13
Event Analysis is an annotation-driven, transcriptional event-based method for transcriptome reference reduction by using the detection and quantification of transcriptonal events (junctions, exons, exon fragments) to identify what transcripts are likely present and which are likely not present given experimental data.

It comprises of a collection of python scripts and example shell submission scripts for Event Analysis. Details on the approach and benchmarking against other methods can be found in the G3:Genomics manuscript (URL to be added).

## Installation instructions

Installation requirements:

Event Analysis requires the following external python modules:
    * pandas (>=0.19.2)
    * pybedtools (>=0.7.10)
    * numpy
    * gffutils

### Installing dependencies

#### Installing dependencies using Anaconda:
NOTE: It is highly recommended you create a new conda environment, as this ensures that you are running/install the correct version of Python and dependencies. To do this, run the command:

    conda create --name event_analysis python=3.6

Then activate this environment:

    conda activate event_analysis

To install these dependencies via Anaconda run the following:

First, add the bioconda and conda-forge repositories using the commands:

    conda config --add channels conda-forge
    conda config --add channels bioconda

Then, to install the dependencies:

    conda install -c jrbnewman event-analysis

#### Installing dependencies manually

You can also install the required python modules manually using pip or conda install. Consult installation instructions for pip/conda install for the packages listed above

### Installing the Event Analysis suite

Create and navigate to the path where you would like to install Event Analysis. For example, if you wanted to create an install in your home directory:

    mkdir -p $HOME/event_analysis
    cd $HOME/event_analysis

Next, clone the git repository for Event Analysis using the command:

    git clone https://github.com/McIntyre-Lab/events

This will create a local copy of the most recent version of Event Analysis in your specified installation folder. If you prefer not to clone the git repository, you can also obtain the code using:

    curl -sL https://github.com/McIntyre-Lab/events/archive/v1.0.13.tar.gz | tar xz --strip 1

This will also unpack the tarball into your Event Analysis install directory.

## Running Event Analysis

Event Analysis can be run either as each individual python script (see event_analysis/src) or  one of the shell scripts under the event_analysis folder (run_buildAnnotations.sh, run_identifyTranscriptome.sh). Two example scripts on how to invoke these shell scripts are also provided in the install directory (example_running_run_buildAnnotations.sh, example_running_run_identifyTranscriptome.sh).

See the README file *event_analysis_workflow_readme.docx* for more information.

## Example data and output

Simulated data and output that was used in the preparing of the manuscript and evelopment of Event Analysis is also available.


