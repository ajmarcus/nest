#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )" 

s3cmd sync $DIR/../src/ s3://nest.hive/src/
