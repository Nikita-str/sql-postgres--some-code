
SET session_replication_role = 'replica';

BEGIN;
SET CONSTRAINTS ALL DEFERRED; --> проверим ограничение один раз, в конце
COPY player_stats_v2 FROM 'C:/OtherPrograms/For_DB/pl_stat#10000.txt' DELIMITER ';';
COPY tour_stats_v2 FROM 'C:/OtherPrograms/For_DB/tr_stat.txt' DELIMITER ';';
COPY game_stats_v2 FROM 'C:/OtherPrograms/For_DB/gm_stat#1000000.txt' DELIMITER ';';
 
--NEXT:CHECK:JSON INSTEAD ARRAY

--COPY player_stats FROM 'C:/Users/newmy/Documents/Study/5_семестр/практикум_БД/code/DB_chess/pl_stat#10000.txt' DELIMITER ';';
--COPY tour_stats FROM 'C:\Users\newmy\Documents\Study\5_семестр\практикум_БД\code\DB_chess\tl_stat.txt' DELIMITER ';';
--COPY game_stats FROM 'C:\Users\newmy\Documents\Study\5_семестр\практикум_БД\code\DB_chess\gm_stat#1000000.txt' DELIMITER ';';
COMMIT;

SET session_replication_role = 'origin';

--SELECT * FROM game_stats_v2 LIMIT 1000;
--SELECT * FROM player_stats_v2 LIMIT 1000;