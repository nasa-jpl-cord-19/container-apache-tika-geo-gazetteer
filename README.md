# apache-tika-geo-gazetteer

Inspired from the instructions found at https://cwiki.apache.org/confluence/display/TIKA/GeoTopicParser.

## Building

### Download the dependencies

```
./download_dependencies.sh
```

### Build the container

```bash
docker build --rm --tag apache-tika-geotopic .
```

## Running

### Running the GeoTopicParser cli tool

```bash
docker run --rm -it --entrypoint lucene-geo-gazetteer apache-tika-geotopic  -s Pasadena Texas -json
```

### Running the GeoTopicParser API server

This is a requirement for the GeoTopicParser enabled tika.

```bash
# Attempt at mirroring the constraints enforced in "production".
docker run --rm -it\
  --read-only=true\
  --cap-drop=all\
  --user="31002:31002"\
  --publish="8765:8765"\
  --name=lucene-geo-gazetteer\
  --entrypoint=lucene-geo-gazetteer\
  apache-tika-geotopic\
    -server
```

```bash
$ curl "http://localhost:8765/api/search?s=Pasadena&s=Texas"
{"Texas":[{"name":"Texas","countryCode":"US","admin1Code":"TX","admin2Code":"","latitude":31.25044,"longitude":-99.25061}],"Pasadena":[{"name":"Pasadena","countryCode":"US","admin1Code":"CA","admin2Code":"037","latitude":34.14778,"longitude":-118.14452}]}
```

### Running GeoTopicParser enabled tika.

Make sure you have the gazetteer server above running

```bash
# startup script needs to write property file, so --read-only is false
docker run --rm -it\
  --read-only=false\
  --cap-drop=all\
  --user="31002:31002"\
  --publish="8182:8182"\
  --name=tika-geo\
  --link=lucene-geo-gazetteer\
  apache-tika-geotopic --port 8182
```

### Testing it all out

```bash
$ curl -T polar.geot -H "Content-Disposition: attachment; filename=polar.geot" http://localhost:8182/rmeta
[{"Content-Type":"application/geotopic","Geographic_LATITUDE":"39.76","Geographic_LONGITUDE":"-98.5","Geographic_NAME":"United States","Optional_LATITUDE1":"35.0","Optional_LONGITUDE1":"105.0","Optional_NAME1":"People’s Republic of China","X-Parsed-By":["org.apache.tika.parser.DefaultParser","org.apache.tika.parser.geo.topic.GeoParser"],"X-TIKA:embedded_depth":"0","X-TIKA:parse_time_millis":"186","resourceName":"polar.geot"}]
```
