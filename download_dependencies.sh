#!/usr/bin/env bash
set -e

if [[ ! -f allCountries.zip ]]; then
    echo "Downloading 'allCountries.zip'"
    curl -O http://download.geonames.org/export/dump/allCountries.zip
fi
if [[ ! -f en-ner-location.bin ]]; then
    echo "Downloading 'en-ner-location.bin'"
    curl -O http://opennlp.sourceforge.net/models-1.5/en-ner-location.bin
fi
if [[ ! -f custom-mimetypes.xml ]]; then
    echo "Downloading 'custom-mimetypes.xml'"
    curl -O https://raw.githubusercontent.com/chrismattmann/geotopicparser-utils/master/mime/org/apache/tika/mime/custom-mimetypes.xml
fi
if [[ ! -f tika-server-1.24.jar ]]; then
    echo "Downloading 'tika-server-1.24.jar'"
    curl -O https://downloads.apache.org/tika/tika-server-1.24.jar
fi
echo "Verifying downloads..."
# We are going to want to let failures continue so we can provide feedback below.
set +e
sha256sum -c dependencies.sha256

if [[ ! $? -eq 0 ]]; then
# I don't know how to indent this to make it pretty.
cat << EOF
****************************************************************************************
One or more files didn't not pass validation. Delete the file that FAILED and try again.
****************************************************************************************
EOF
fi