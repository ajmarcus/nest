#!/bin/sh

lappy_emr --create --alive --hive-interactive \
  --name 'hive nest' \
  --instance-group master --instance-count 1 \
  --instance-type m2.xlarge \
  --instance-group core --instance-type m2.xlarge \
  --instance-count 1
