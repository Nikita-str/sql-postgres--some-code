
--no permition: UPDATE player_stats SET about_tactic='zero' WHERE player_stats_id = 12; 

--ok:
UPDATE player_stats SET rating[2]=1496 WHERE player_stats_id = 12; 
SELECT rating FROM player_stats WHERE player_stats_id = 12; 
UPDATE player_stats SET rating[2]=1500 WHERE player_stats_id = 12; 
SELECT rating FROM player_stats WHERE player_stats_id = 12; 

UPDATE tour_stats SET tour_year_start = 1995 WHERE tour_id = 3;
SELECT * FROM tour_stats WHERE tour_id = 3;
UPDATE tour_stats SET tour_year_start = 1996 WHERE tour_id = 3;
SELECT * FROM tour_stats WHERE tour_id = 3;

--error :SELECT * FROM player_stats WHERE player_stats_id = 2; т.к. у нас нет прав на просмотр всех столбцов
SELECT rating FROM player_stats WHERE player_stats_id = 2;

SELECT * FROM tour_map_viewer;
--error: INSERT INTO tour_map_viewer VALUES (20202020, 2020);


UPDATE player_peak_1500 SET rating[3] = 1503 WHERE player_stats_id = 25;
SELECT * FROM player_peak_1500 WHERE player_stats_id = 25;
UPDATE player_peak_1500 SET rating[3] = 1505 WHERE player_stats_id = 25; --ok


SELECT count(*) FROM player_peak_1500;
--если player_peak_1500 создан с WITH CHECK OPTION то будет
--ошибка т.к. тогда у данного игрока максимальный рэйтинг будет < 1500.
--если же без, то SELECT count(*) FROM player_peak_1500; станет выдовать на 1 меньше:
--UPDATE player_peak_1500 SET rating[3] = 404 WHERE player_stats_id = 25;


UPDATE player_stats SET rating[3] = 1499 WHERE player_stats_id = 25;
SELECT count(*) FROM player_peak_1500;
UPDATE player_stats SET rating[3] = 1503 WHERE player_stats_id = 25;



--SELECT SESSION_USER, CURRENT_USER;



