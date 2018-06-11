# Run setup.py to install the required python packages
$PYTHON setup.py install --single-version-externally-managed --record=record.txt  # Python command to install the script.

# copy executable scripts and documentation to install directory
if [ ! -e $(pwd)/event_analysis ]; then mkdir -p $(pwd)/event_analysis; fi
cp -r ${RECIPE_DIR}/event_analysis/* $(pwd)/event_analysis/.
