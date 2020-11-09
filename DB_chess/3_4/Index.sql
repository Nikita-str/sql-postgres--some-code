ERROR 
--ANALYZE

--для проверки что свыше 3500 зрителей - редко
--SELECT game_stat_id FROM game_stats WHERE get_game_viewer_sum(viewer_amount) > 3500 LIMIT 10; 


--======================================================================================================================================================
--======================================================================================================================================================
--Seq Scan on game_stats  (cost=0.00..28803855.38 rows=1621130 width=4):
EXPLAIN SELECT game_stat_id FROM game_stats
WHERE get_game_viewer_sum(viewer_amount) > 3500 AND p1_rating > 1500 AND p1_rating <= p2_rating; 

--Seq Scan on game_stats  (cost=0.00..28803855.38 rows=1621130 width=4) (actual time=149567.273..149567.274 rows=0 loops=1)
--Execution Time: 149567.309 ms  = 149s > 2m 
--Rows Removed by Filter: 100000000
EXPLAIN (ANALYZE) SELECT game_stat_id FROM game_stats
WHERE get_game_viewer_sum(viewer_amount) > 3500 AND p1_rating > 1500 AND p1_rating <= p2_rating; 

--Seq Scan on game_stats  (cost=0.00..28803855.38 rows=20616633 width=4) (actual time=33.394..1224326.708 rows=27662 loops=1)
--Execution Time: 1224346.646 ms = 1224s = 20m
--Rows Removed by Filter: 99972338
EXPLAIN (ANALYZE) SELECT game_stat_id FROM game_stats
WHERE get_game_viewer_sum(viewer_amount) > 3500 AND p1_rating > 1050 AND p2_rating > 1050;
------------------------------------------------------------------------------------------------------------------
--Теперь создаем индексы:
CREATE INDEX p1_rating_idx ON game_stats (p1_rating);--8min 24 s
CREATE INDEX view_sum_idx ON game_stats (get_game_viewer_sum(viewer_amount));--38min
ANALYZE

--Index Scan using view_sum_idx on game_stats  (cost=0.57..733224.45 rows=116785 width=4) (actual time=0.128..26397.158 rows=27662 loops=1)
-- Index Cond: (get_game_viewer_sum(viewer_amount) > 3500)
-- Rows Removed by Filter: 20897
--Execution Time: 26430.424 ms = 26.5s  // second time: Execution Time: 2738.907 ms = 2.5s
EXPLAIN (ANALYZE) SELECT game_stat_id FROM game_stats
WHERE get_game_viewer_sum(viewer_amount) > 3500 AND p1_rating > 1050 AND p2_rating > 1050;

--Limit  (cost=0.57..7372.14 rows=1000 width=8) (actual time=5.650..529.069 rows=1000 loops=1)
--Execution Time: 530.546 ms = 0.5s
EXPLAIN (ANALYZE) SELECT game_stat_id FROM game_stats
WHERE p1_rating > 1300 AND p2_rating > 1300 ORDER BY p1_rating LIMIT 1000;
--======================================================================================================================================================
--======================================================================================================================================================

EXPLAIN (ANALYZE) SELECT game_stat_id FROM game_stats gs JOIN tour_stats ts
ON get_game_viewer_sum(viewer_amount) > 3500 AND gs.tour_id = ts.tour_id AND tour_year_start = 2019;


/*
"Hash Join  (cost=169.51..3319116.37 rows=8927302 width=4) (actual time=101960.619..158426.003 rows=8735564 loops=1)"
"  Hash Cond: (gs.tour_id = ts.tour_id)"
"  ->  Seq Scan on game_stats gs  (cost=0.00..3056248.96 rows=99996896 width=8) (actual time=0.245..114908.559 rows=100000000 loops=1)"
"  ->  Hash  (cost=163.49..163.49 rows=482 width=4) (actual time=3.375..3.377 rows=482 loops=1)"
"        Buckets: 1024  Batches: 1  Memory Usage: 25kB"
"        ->  Seq Scan on tour_stats ts  (cost=0.00..163.49 rows=482 width=4) (actual time=2.738..3.018 rows=482 loops=1)"
"              Filter: (tour_year_start = 2019)"
"              Rows Removed by Filter: 4917"
"Planning Time: 0.759 ms"
"Execution Time: 159065.784 ms" = 2.5 min
*/
EXPLAIN (ANALYZE) SELECT game_stat_id FROM game_stats gs JOIN tour_stats ts
ON /*get_game_viewer_sum(viewer_amount) > 3500 AND*/ gs.tour_id = ts.tour_id AND tour_year_start = 2019;
---------------------------------------------------------------------------------------------------------------

/*
"Nested Loop  (cost=0.85..1063930.69 rows=8927579 width=4) (actual time=2.534..19413.715 rows=8735564 loops=1)"
"  ->  Index Scan using tour_stats_pkey on tour_stats ts  (cost=0.28..297.03 rows=482 width=4) (actual time=1.831..7.077 rows=482 loops=1)"
"        Filter: (tour_year_start = 2019)"
"        Rows Removed by Filter: 4917"
"  ->  Index Scan using game_tour_id_idx on game_stats gs  (cost=0.57..2017.96 rows=18875 width=8) (actual time=0.049..32.737 rows=18124 loops=482)"
"        Index Cond: (tour_id = ts.tour_id)"
"Planning Time: 0.680 ms"
"Execution Time: 20818.614 ms" = 20s
*/
CREATE INDEX game_tour_id_idx ON game_stats (tour_id);
ANALYZE
EXPLAIN (ANALYZE) SELECT game_stat_id FROM game_stats gs JOIN tour_stats ts
ON /*get_game_viewer_sum(viewer_amount) > 3500 AND*/ tour_year_start = 2019 AND gs.tour_id = ts.tour_id;
--======================================================================================================================================================
--======================================================================================================================================================
/*
"Limit  (cost=263078.04..263078.04 rows=1 width=179)"
"  ->  Sort  (cost=263078.04..263078.04 rows=1 width=179)"
"        Sort Key: player_stats_id DESC"
"        ->  Gather  (cost=1000.00..263078.03 rows=1 width=179)"
"              Workers Planned: 2"
"              ->  Parallel Seq Scan on player_stats  (cost=0.00..262077.93 rows=1 width=179)"
"                    Filter: (to_tsvector('english'::regconfig, about_tactic) @@ to_tsquery('(often<->use<->forks) & (own<->style)'::text))"
выполнялся больше 2х минут, ну короче ему надо по все было пройти и потом ORDER BY сделать
*/
EXPLAIN SELECT player_stats_id, about_tactic FROM player_stats
WHERE to_tsvector('english', about_tactic) @@ to_tsquery('(often<->use<->forks) & (own<->style)') 
ORDER BY player_stats_id DESC
LIMIT 100;

/*
"Limit  (cost=1000.00..263078.03 rows=1 width=179) (actual time=7.289..2357.184 rows=1000 loops=1)"
"  ->  Gather  (cost=1000.00..263078.03 rows=1 width=179) (actual time=7.287..2356.692 rows=1000 loops=1)"
"        Workers Planned: 2"
"        Workers Launched: 2"
"        ->  Parallel Seq Scan on player_stats  (cost=0.00..262077.93 rows=1 width=179) (actual time=7.750..2128.781 rows=334 loops=3)"
"              Filter: (to_tsvector('english'::regconfig, about_tactic) @@ to_tsquery('(often<->use<->forks) & (own<->style)'::text))"
"              Rows Removed by Filter: 12908"
"Planning Time: 0.338 ms"
"Execution Time: 2357.676 ms"
*/
EXPLAIN (ANALYZE) SELECT player_stats_id, about_tactic FROM player_stats
WHERE to_tsvector('english', about_tactic) @@ to_tsquery('(often<->use<->forks) & (own<->style)') 
LIMIT 1000;
 
 
---------------------------------------------------------------------------------------------------------------
CREATE INDEX sea_idx ON player_stats USING GIN (to_tsvector('english', about_tactic));--3 min

/*
"Limit  (cost=44.25..48.76 rows=1 width=179) (actual time=66.805..298.486 rows=1000 loops=1)"
"  ->  Bitmap Heap Scan on player_stats  (cost=44.25..48.76 rows=1 width=179) (actual time=66.802..297.795 rows=1000 loops=1)"
"        Recheck Cond: (to_tsvector('english'::regconfig, about_tactic) @@ to_tsquery('(often<->use<->forks) & (own<->style)'::text))"
"        Rows Removed by Index Recheck: 2"
"        Heap Blocks: exact=790"
"        ->  Bitmap Index Scan on sea_idx  (cost=0.00..44.25 rows=1 width=0) (actual time=58.831..58.831 rows=24816 loops=1)"
"              Index Cond: (to_tsvector('english'::regconfig, about_tactic) @@ to_tsquery('(often<->use<->forks) & (own<->style)'::text))"
"Planning Time: 1.468 ms"
"Execution Time: 299.244 ms"
*/
EXPLAIN (ANALYZE) SELECT player_stats_id, about_tactic FROM player_stats
WHERE to_tsvector('english', about_tactic) @@ to_tsquery('(often<->use<->forks) & (own<->style)') 
LIMIT 1000;
 
/*
"Limit  (cost=48.77..48.78 rows=1 width=179) (actual time=5092.189..5092.702 rows=1000 loops=1)"
"  ->  Sort  (cost=48.77..48.78 rows=1 width=179) (actual time=5092.187..5092.453 rows=1000 loops=1)"
"        Sort Key: player_stats_id DESC"
"        Sort Method: top-N heapsort  Memory: 563kB"
"        ->  Bitmap Heap Scan on player_stats  (cost=44.25..48.76 rows=1 width=179) (actual time=65.543..5004.025 rows=24709 loops=1)"
"              Recheck Cond: (to_tsvector('english'::regconfig, about_tactic) @@ to_tsquery('(often<->use<->forks) & (own<->style)'::text))"
"              Rows Removed by Index Recheck: 107"
"              Heap Blocks: exact=19577"
"              ->  Bitmap Index Scan on sea_idx  (cost=0.00..44.25 rows=1 width=0) (actual time=56.721..56.721 rows=24816 loops=1)"
"                    Index Cond: (to_tsvector('english'::regconfig, about_tactic) @@ to_tsquery('(often<->use<->forks) & (own<->style)'::text))"
"Planning Time: 0.305 ms"
"Execution Time: 5093.342 ms"
*/
EXPLAIN (ANALYZE) SELECT player_stats_id, about_tactic FROM player_stats
WHERE to_tsvector('english', about_tactic) @@ to_tsquery('(often<->use<->forks) & (own<->style)') 
ORDER BY player_stats_id DESC
LIMIT 1000;
--======================================================================================================================================================
--======================================================================================================================================================

/*
"Gather  (cost=1000.00..56279.01 rows=5000 width=356) (actual time=5.336..2510.670 rows=140 loops=1)"
"  Workers Planned: 2"
"  Workers Launched: 2"
"  ->  Parallel Seq Scan on player_stats  (cost=0.00..54779.01 rows=2083 width=356) (actual time=21.907..2198.222 rows=47 loops=3)"
"        Filter: ((player_info ->> 'second_name'::text) = 'adam'::text)"
"        Rows Removed by Filter: 333287"
"Planning Time: 0.199 ms"
"Execution Time: 2510.807 ms" = 2.5s
*/
EXPLAIN (ANALYZE) SELECT * FROM player_stats WHERE player_info->>'second_name' = 'adam';

CREATE INDEX info_sname_idx ON player_stats USING HASH ((player_info->>'second_name')); --14s

/*
"Bitmap Heap Scan on player_stats  (cost=134.75..14767.09 rows=5000 width=356) (actual time=0.189..5.209 rows=140 loops=1)"
"  Recheck Cond: ((player_info ->> 'second_name'::text) = 'adam'::text)"
"  Heap Blocks: exact=140"
"  ->  Bitmap Index Scan on info_sname_idx  (cost=0.00..133.50 rows=5000 width=0) (actual time=0.060..0.061 rows=140 loops=1)"
"        Index Cond: ((player_info ->> 'second_name'::text) = 'adam'::text)"
"Planning Time: 1.052 ms"
"Execution Time: 5.295 ms"
*/
EXPLAIN (ANALYZE) SELECT * FROM player_stats WHERE player_info->>'second_name' = 'adam';
--======================================================================================================================================================
--======================================================================================================================================================

