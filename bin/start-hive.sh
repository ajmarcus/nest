#!/bin/sh

lappy_emr='/home/openbi/emr/elastic-mapreduce-cli/elastic-mapreduce -c /home/openbi/.emr/lappy.json'

$lappy_emr --create --alive --hive-interactive \
  --name 'hive nest' \
  --instance-group master --instance-count 1 \
  --instance-type m2.xlarge \
  --instance-group core --instance-type m2.xlarge \
  --instance-count 1 \
  --jar s3://us-east-1.elasticmapreduce/libs/script-runner/script-runner.jar \
  --args "s3://nest.hive/src/hive_init.sh"
