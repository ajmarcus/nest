wc -l yelp.json
474434

select count(1) from raw_nest;
474434


select count(1) from fact_nest;
474434

select type, count(1) from fact_nest group by type;
business  13490
review  330071
user  130873

