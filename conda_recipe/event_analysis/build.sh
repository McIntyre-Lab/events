# Run setup.py to install the required python packages
$PYTHON event_analysis/setup.py install --single-version-externally-managed --record=record.txt  # Python command to install the script.

# copy executable scripts and documentation to install directory
## If user has set up an install path for Event Analysis use that
## otherwise put it into the home directory

if [[ -z ${EVENT_ANALYSIS_INSTALL_PATH} ]];
    then mkdir -p $HOME/event_analysis
    cd $HOME/event_analysis
else if [[ ! -e ${EVENT_ANALYSIS_INSTALL_PATH} ]];
     then mkdir -p ${EVENT_ANALYSIS_INSTALL_PATH}
     cd ${EVENT_ANALYSIS_INSTALL_PATH}
     fi
fi

curl -sL https://github.com/McIntyre-Lab/events/archive/v1.0.7.tar.gz | tar xz

