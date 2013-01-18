#!/bin/sh

# Change this to point to your downloaded copy of the ruby elastic-mapreduce client
lappy_emr='/home/openbi/emr/elastic-mapreduce-cli/elastic-mapreduce -c /home/openbi/.emr/lappy.json'

$lappy_emr --create --alive --hive-interactive \
  --name 'hive nest' \
  --instance-group master --instance-count 1 \
  --instance-type m2.xlarge \
  --instance-group core --instance-type m2.xlarge \
  --instance-count 1 \
  --hive-script "s3://nest.hive/src/nest.ddl" \
  --step-name "Run Nest ddl"
