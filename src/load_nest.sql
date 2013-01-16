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


insert overwrite table dw.tmp_fact_nest
    select type
        ,average_stars*10000
        ,business_id
        ,categories
        ,city
        ,date_time
        ,full_address
        ,latitude
        ,longitude
        ,name
        ,neighborhoods
        ,open
        ,photo_url
        ,review_count
        ,review_id
        ,schools
        ,stars
        ,state
        ,review_text
        ,url
        ,user_id
        ,votes
    from dw.raw_nest raw
    lateral view json_tuple(raw.row_json,'type'
    ,'average_stars'
    ,'business_id'
    ,'categories'
    ,'city'
    ,'date'
    ,'full_address'
    ,'latitude'
    ,'longitude'
    ,'name'
    ,'neighborhoods'
    ,'open'
    ,'photo_url'
    ,'review_count'
    ,'review_id'
    ,'schools'
    ,'stars'
    ,'state'
    ,'text'
    ,'url'
    ,'user_id'
    ,'votes') j as 
        type
        ,average_stars
        ,business_id
        ,categories
        ,city
        ,date_time
        ,full_address
        ,latitude
        ,longitude
        ,name
        ,neighborhoods
        ,open
        ,photo_url
        ,review_count
        ,review_id
        ,schools
        ,stars
        ,state
        ,review_text
        ,url
        ,user_id
        ,votes;



insert overwrite table dw.dim_user
    select tmp.user_id,
        tmp.name,
        tmp.review_count,
        tmp.average_stars,
        j.votes_useful,
        j.votes_funny,
        j.votes_cool
    from tmp_fact_nest tmp
    lateral view json_tuple(tmp.votes
        , 'useful'
        , 'funny'
        , 'cool'
        ) j as 
        votes_useful
        , votes_funny
        , votes_cool
    where tmp.type='user';



insert overwrite table dw.dim_business
    select tmp.business_id,
        tmp.name,
        tmp.neighborhoods,
        tmp.full_address,
        tmp.city,
        tmp.state,
        tmp.latitude,
        tmp.longitude,
        tmp.stars,
        tmp.review_count,
        tmp.photo_url,
        tmp.categories,
        tmp.open,
        tmp.schools,
        tmp.url
    from tmp_fact_nest tmp
    where tmp.type='business';


insert overwrite table dw.fact_review
    select tmp.business_id,
        tmp.user_id,
        tmp.stars,
        tmp.review_text,
        tmp.day_date,
        j.votes_useful,
        j.votes_funny,
        j.votes_cool
    from tmp_fact_nest tmp
    lateral view json_tuple(tmp.votes
        , 'useful'
        , 'funny'
        , 'cool'
        ) j as 
        votes_useful
        , votes_funny
        , votes_cool
    where tmp.type='review';