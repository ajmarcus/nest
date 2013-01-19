#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )"

echo 'Run jive ddl'
hive -f $DIR/../src/jive_local.ddl

echo 'Parse yelp json'
hive -f $DIR/../src/load_tmp_fact_yelp.sql

echo 'Load dimensions'
hive -f $DIR/../src/load_dims.sql

echo 'Load facts'
hive -f $DIR/../src/load_facts.sql
