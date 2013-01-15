use dw;

insert overwrite table dw.fact_nest
    select type
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
        ,text
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
        ,text
        ,url
        ,user_id
        ,votes;
