# Run setup.py to install the required python packages
$PYTHON event_analysis/setup.py install --single-version-externally-managed --record=record.txt  # Python command to install the script.

# copy executable scripts and documentation to install directory
if [ ! -e $(pwd)/event_analysis ]; then mkdir -p $(pwd)/event_analysis; fi
cp -r ${RECIPE_DIR}/* $(pwd)/event_analysis
