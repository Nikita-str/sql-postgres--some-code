
DROP /*MATERIALIZED*/ VIEW IF EXISTS player_peak_1500;
-- эти данные занимают не слишком много места, поэтому их впринципе можно запомнить, 
-- но тогда в случае новых данных мы можем что-то упустить если не обновим прежде.  
--
-- можно и не запоминать, так как время выполнения ~ 1.5-3 секунд 
-- увеличение скорости выполнение(раз): ((1.5+6)/2 - 0.2)/0.2 ~= 17.5
CREATE /*MATERIALIZED*/ VIEW player_peak_1500 AS 
SELECT * FROM player_stats 
WHERE 1500 <= ANY(rating)
WITH CHECK OPTION;

--EXPLAIN ANALYZE 
SELECT count(*) FROM player_peak_1500;

--YOU DONT WANT TO DO IT, IT TAKE LONG : DROP MATERIALIZED VIEW IF EXISTS tour_map_viewer;

-- увеличение скорости выполнение(раз): (600 - 0.2)/0.2 ~= 3000  (600 = 10 min, 0.2 - время выполнения SELECT * FROM tour_map_viewer DESC)
--it's take 10 min & very little memory (5400 lines) but now, for example, we can fast find organizators who gather a large audience
CREATE MATERIALIZED VIEW tour_map_viewer AS
WITH temp_table AS 
(SELECT tour_id, (SELECT SUM(viewer) FROM UNNEST(viewer_amount) viewer) AS tid_viewer FROM game_stats)
SELECT tour_id, SUM(tid_viewer) AS sum_viewer FROM temp_table GROUP BY tour_id;

--but it ~200 ms  :|
SELECT * FROM tour_map_viewer ORDER BY sum_viewer DESC;


CREATE ROLE std_role_1;
GRANT SELECT ON tour_map_viewer TO std_role_1;
GRANT SELECT, UPDATE(rating_date, rating) ON player_peak_1500 TO std_role_1;

GRANT std_role_1 TO test;






