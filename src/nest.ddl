set hive.cli.print.current.db=true;
set hive.cli.print.header=true;
set hive.optimize.s3.query=true;
set mapred.map.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;
set hive.exec.compress.intermediate=true;

create database if not exists dw
    location 's3://nest.hive/dw';

use dw;

create external table if not exists dw.raw_nest
    ( row_json STRING )
row format delimited
lines terminated by '\n'
location 's3://nest.hive/raw/';

create table if not exists dw.fact_nest
    ( type STRING comment 'Indicates whether the row is a business, review or user',
      average_stars INT comment 'Average Stars multiplied by 10,000',
      business_id STRING comment 'Unique identifier for the business',
      categories STRING comment 'Array of localized category names',
      city STRING comment 'Location of business',
      date_time STRING comment 'Date of review in YYYY-MM-DD format',
      full_address STRING comment 'Localized address',
      latitude STRING comment 'Location of business',
      longitude STRING comment 'Location of business',
      name STRING comment 'First name and last initial of user',
      neighborhoods STRING comment 'Possibly null array of neighborhood names',
      open STRING comment 'Whether the business is still open',
      photo_url STRING comment 'URL of business photo',
      review_count STRING comment 'Number of reviews of the business',
      review_id STRING comment 'Unique identifier for a review',
      schools STRING comment 'Array of nearby universities',
      stars INT comment 'Star rating of review',
      state STRING comment 'Location of business',
      text STRING comment 'Review text',
      url STRING comment 'Yelp URL for a business',
      user_id STRING comment 'Unique identifier for a user',
      votes STRING comment 'Object with counts of useful, funny and cool reviews' )
stored as sequencefile;
