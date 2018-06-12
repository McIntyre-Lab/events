# Run setup.py to install the required python packages

echo "Setting up install path"
if [[ -z ${EVENT_ANALYSIS_INSTALL_PATH} ]];
    then mkdir -p $HOME/event_analysis
    cd $HOME/event_analysis
else if [[ ! -e ${EVENT_ANALYSIS_INSTALL_PATH} ]];
     then mkdir -p ${EVENT_ANALYSIS_INSTALL_PATH}
     cd ${EVENT_ANALYSIS_INSTALL_PATH}
     fi
fi

echo "Downloading Event Analysis source code into install path (defaults to ~/event_analysis) ..."
curl -sL https://github.com/McIntyre-Lab/events/archive/v1.0.9.tar.gz | tar xz

