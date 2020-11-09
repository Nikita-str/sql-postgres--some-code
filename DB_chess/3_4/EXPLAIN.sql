EXPLAIN SELECT * FROM game_stats;

EXPLAIN SELECT * FROM game_stats WHERE p1_rating < p2_rating;

EXPLAIN SELECT * FROM game_stats WHERE p1_rating < p2_rating LIMIT 1000;
EXPLAIN ANALYZE SELECT * FROM game_stats WHERE p1_rating < p2_rating LIMIT 1000;
EXPLAIN (VERBOSE, ANALYZE) SELECT * FROM game_stats WHERE p1_rating < p2_rating LIMIT 1000;

EXPLAIN SELECT * FROM game_stats WHERE get_game_viewer_sum(viewer_amount) > 500000000;--actually 0 rows

EXPLAIN SELECT ts.tour_name FROM game_stats gs JOIN tour_stats ts 
ON gs.tour_id = ts.tour_id;

--EXPLAIN SELECT DISTINCT ts.tour_name FROM game_stats gs JOIN tour_stats ts ON gs.tour_id = ts.tour_id; -- думал тут будут какие-нибудь оптимизации а их нет 

EXPLAIN SELECT gs.* FROM game_stats gs JOIN tour_stats ts 
ON gs.tour_id = ts.tour_id AND ts.tour_year_start = 2020;


EXPLAIN UPDATE tour_stats SET tour_year_start = tour_year_start + 1 WHERE tour_year_start = 2020; 

