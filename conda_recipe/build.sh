# Run setup.py to install the required python packages
$PYTHON setup.py install --single-version-externally-managed --record=record.txt  # Python command to install the script.

# copy executable scripts to bin/
mkdir -p ${PREFIX}/src
cp -r ${RECIPE_DIR}/event_analysis/bin/* ${PREFIX}/bin/.

# Copy documentation to docs/
mkdir -p ${PREFIX}/docs
cp -r ${RECIPE_DIR}/event_analysis/docs/* ${PREFIX}/docs/.






