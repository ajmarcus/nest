use dw;

-- load tmp table by parsing raw logs

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

-- load users

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

-- load businesses

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

-- load reviews
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