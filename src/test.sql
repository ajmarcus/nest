-- Total number of rows
wc -l yelp.json
474434

-- Loaded to s3 correctly
select count(1) from raw_yelp;
474434

-- JSON parsed without error
select count(1) from tmp_fact_yelp;
474434

-- Number of each type of row
select type, count(1) from tmp_fact_yelp group by type;
business  13490
review  330071
user  130873

-- No duplicate businesses
select count(1) from ( select business_id from tmp_fact_yelp where type='business' group by business_id having count(1) > 1 ) q;
0

-- No duplicate users
select count(1) from ( select user_id from tmp_fact_yelp where type='user' group by user_id having count(1) > 1 ) q ;
0

-- No business with many reviews from one user
select count(1) from ( select business_id,user_id from tmp_fact_yelp where type='review' group by business_id,user_id having count(1) > 1 ) q ;
0