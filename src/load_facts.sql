-- Load fact tables

use dw;

-- Review facts

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

insert overwrite table dw.fact_review_denorm
    select 
        f.business_id
        , f.user_id
        , f.stars as review_stars
        , f.review_text
        , f.day_date as review_day_date
        , f.votes_useful as review_votes_useful
        , f.votes_funny as review_votes_funny
        , f.votes_cool as review_votes_cool
        , u.name as user_name
        , u.review_count as user_review_count
        , u.average_stars as user_average_stars
        , u.votes_useful as user_votes_useful
        , u.votes_funny as user_votes_funny
        , u.votes_cool as user_votes_cool
        , b.name as business_name
        , b.neighborhoods as business_neighborhoods
        , b.full_address as business_full_address
        , b.city as business_city
        , b.state as business_state
        , b.latitude as business_latitude
        , b.longitude as business_longitude
        , b.stars as business_stars
        , b.review_count as business_review_count
        , b.photo_url as business_photo_url
        , b.categories as business_categories
        , b.open as business_open
        , b.schools as business_schools
        , b.url as business_url
    from fact_review f
    join dim_user u
        on f.user_id = u.user_id
    join dim_business b
        on f.business_id = b.business_id;
