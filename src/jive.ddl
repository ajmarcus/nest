set hive.cli.print.current.db=true;
set hive.cli.print.header=true;
set hive.optimize.s3.query=true;
set mapred.map.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;
set hive.exec.compress.intermediate=true;

create database if not exists dw
    location 's3://nest.hive/dw';

use dw;

-- tmp tables

create external table if not exists dw.raw_nest
    ( row_json STRING )
row format delimited
lines terminated by '\n'
location 's3://nest.hive/raw/';

create table if not exists dw.tmp_fact_nest
    ( type STRING comment 'Indicates whether the row is a business, review or user',
    average_stars INT comment 'Average Stars multiplied by 10,000',
    business_id STRING comment 'Unique identifier for the business',
    categories STRING comment 'Array of localized category names',
    city STRING comment 'Location of business',
    day_date STRING comment 'Date of review in YYYY-MM-DD format',
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
    review_text STRING comment 'Review text',
    url STRING comment 'Yelp URL for a business',
    user_id STRING comment 'Unique identifier for a user',
    votes STRING comment 'Object with counts of useful, funny and cool reviews' )
stored as sequencefile;


--dimensions

create table if not exists dw.dim_business
    ( business_id STRING comment 'a unique identifier for this business',
    name STRING comment 'the full business name',
    neighborhoods STRING comment 'a list of neighborhood names, might be empty',
    full_address STRING comment 'localized address',
    city STRING comment 'city',
    state STRING comment 'state',
    latitude STRING comment 'latitude',
    longitude STRING comment 'longitude',
    stars STRING comment 'star rating, rounded to half-stars',
    review_count STRING comment 'review count',
    photo_url STRING comment 'photo url',
    categories STRING comment 'Array of localized category names',
    open STRING comment 'is the business still open for business?',
    schools STRING comment 'nearby universities',
    url STRING comment 'yelp url' )
stored as sequencefile;

create table if not exists dw.dim_user
    ( user_id STRING comment 'unique user identifier',
    name STRING comment 'first name and last initial of user',
    review_count STRING comment 'review count',
    average_stars INT comment 'average stars multiplied by 10,000',
    votes_useful STRING comment 'count of useful votes across all reviews',
    votes_funny STRING comment 'count of funny votes across all reviews',
    votes_cool STRING comment 'count of cool votes across all reviews' )
stored as sequencefile;

-- facts

create table if not exists dw.fact_review 
    ( business_id STRING comment 'the identifier of the reviewed business',
    user_id STRING comment 'the identifier of the authoring user',
    stars INT comment 'star rating, integer 1-5',
    review_text STRING comment 'review text',
    day_date STRING comment 'date formatted YYYY-MM-DD ',
    votes_useful STRING comment 'count of useful votes',
    votes_funny STRING comment 'count of funny votes',
    votes_cool STRING comment 'count of cool votes' )
stored as sequencefile;


create table if not exists dw.fact_review_denorm 
    ( business_id STRING comment 'the identifier of the reviewed business',
    user_id STRING comment 'the identifier of the authoring user',
    review_stars INT comment 'star rating, integer 1-5',
    review_text STRING comment 'review text',
    review_day_date STRING comment 'date formatted YYYY-MM-DD ',
    review_votes_useful STRING comment 'count of useful votes',
    review_votes_funny STRING comment 'count of funny votes',
    review_votes_cool STRING comment 'count of cool votes',
    user_name STRING comment 'first name and last initial of user',
    user_review_count STRING comment 'review count',
    user_average_stars INT comment 'average stars multiplied by 10,000',
    user_votes_useful STRING comment 'count of useful votes across all reviews',
    user_votes_funny STRING comment 'count of funny votes across all reviews',
    user_votes_cool STRING comment 'count of cool votes across all reviews',
    business_name STRING comment 'the full business name',
    business_neighborhoods STRING comment 'a list of neighborhood names, might be empty',
    business_full_address STRING comment 'localized address',
    business_city STRING comment 'city',
    business_state STRING comment 'state',
    business_latitude STRING comment 'latitude',
    business_longitude STRING comment 'longitude',
    business_stars STRING comment 'star rating, rounded to half-stars',
    business_review_count STRING comment 'review count',
    business_photo_url STRING comment 'photo url',
    business_categories STRING comment 'Array of localized category names',
    business_open STRING comment 'is the business still open for business?',
    business_schools STRING comment 'nearby universities',
    business_url STRING comment 'yelp url' )
stored as sequencefile;