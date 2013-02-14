#!/bin/sh

# Change this to point to your downloaded copy of the ruby elastic-mapreduce client
lappy_emr='/home/openbi/emr/elastic-mapreduce-cli/elastic-mapreduce -c /home/openbi/.emr/lappy.json'

$lappy_emr --create \
  --name 'jitterbug' \
  --instance-group master --instance-count 1 \
  --instance-type m2.xlarge \
  --instance-group core --instance-type m2.xlarge \
  --instance-count 1 \
  --hive-script "s3://nest.hive/src/jive.ddl" \
  --step-name "Run jive ddl" \
  --hive-script "s3://nest.hive/src/load_tmp_fact_yelp.sql" \
  --step-name "Parse yelp json" \
  --hive-script "s3://nest.hive/src/load_dims.sql" \
  --step-name "Load dimensions" \
  --hive-script "s3://nest.hive/src/load_facts.sql" \
  --step-name "Load facts"
