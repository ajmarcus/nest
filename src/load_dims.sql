use dw;

-- load users

insert overwrite table dw.dim_user
  select distinct 
    tmp.user_id,
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
  select distinct 
    tmp.business_id,
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