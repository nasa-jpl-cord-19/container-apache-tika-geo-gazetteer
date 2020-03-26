#!/usr/bin/env bash

# LUCENE_GEO_GAZETTEER_PORT=tcp://172.17.0.2:8765

if [[ ! -z "${LUCENE_GEO_GAZETTEER_PORT}" ]]; then
    GAZETTEER_ENDPOINT="http://${LUCENE_GEO_GAZETTEER_PORT:6}"
fi

if [[ -z "${GAZETTEER_ENDPOINT}" ]]; then
    echo "The environment variable GAZETTEER_ENDPOINT needs to be set"
    exit 1
fi

echo "setting gazetter.rest.api=${GAZETTEER_ENDPOINT}"
echo "gazetter.rest.api=${GAZETTEER_ENDPOINT}" > "${PWD}/resources/org/apache/tika/parser/geo/topic/GeoTopicConfig.properties"

java -server -classpath "${PWD}/resources:${PWD}/tika-server-1.24.jar" org.apache.tika.server.TikaServerCli -h 0.0.0.0 $@