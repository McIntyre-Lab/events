# Run setup.py to install the required python packages
echo "Installing Event Analysis dependencies ..."
$PYTHON event_analysis/setup.py install --single-version-externally-managed --record=record.txt  # Python command to install the script.

