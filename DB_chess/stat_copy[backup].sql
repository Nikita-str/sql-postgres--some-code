ERROR 
YOU
ARE 
SURE

BEGIN;
--SET session_replication_role = 'replica';
--SET CONSTRAINTS ALL DEFERRED; --> проверим ограничение один раз, в конце
COPY player_stats FROM 'C:/OtherPrograms/For_DB/pl_stat#1000000.txt' DELIMITER ';';
COPY tour_stats FROM 'C:/OtherPrograms/For_DB/tr_stat.txt' DELIMITER ';';

COPY game_stats FROM 'C:/OtherPrograms/For_DB/gm_stat#100000000_1.txt' DELIMITER ';';
COPY game_stats FROM 'C:/OtherPrograms/For_DB/gm_stat#100000000_2.txt' DELIMITER ';';
COPY game_stats FROM 'C:/OtherPrograms/For_DB/gm_stat#100000000_3.txt' DELIMITER ';';
COPY game_stats FROM 'C:/OtherPrograms/For_DB/gm_stat#100000000_4.txt' DELIMITER ';';
COPY game_stats FROM 'C:/OtherPrograms/For_DB/gm_stat#100000000_5.txt' DELIMITER ';';
--COPY player_stats FROM 'C:/Users/newmy/Documents/Study/5_семестр/практикум_БД/code/DB_chess/pl_stat#10000.txt' DELIMITER ';';
--COPY tour_stats FROM 'C:\Users\newmy\Documents\Study\5_семестр\практикум_БД\code\DB_chess\tl_stat.txt' DELIMITER ';';
--COPY game_stats FROM 'C:\Users\newmy\Documents\Study\5_семестр\практикум_БД\code\DB_chess\gm_stat#1000000.txt' DELIMITER ';';
--SET session_replication_role = 'origin';
COMMIT;


ALTER TABLE player_stats ADD PRIMARY KEY (player_stats_id);
ALTER TABLE tour_stats ADD PRIMARY KEY (tour_id);
ALTER TABLE game_stats ADD PRIMARY KEY (game_stat_id);
ALTER TABLE game_stats ADD FOREIGN KEY (tour_id) REFERENCES tour_stats(tour_id);
ALTER TABLE game_stats ADD FOREIGN KEY (player_1_id) REFERENCES player_stats(player_stats_id);
ALTER TABLE game_stats ADD FOREIGN KEY (player_2_id) REFERENCES player_stats(player_stats_id);
ALTER TABLE game_stats ALTER player_1_id SET NOT NULL;
ALTER TABLE game_stats ALTER player_2_id SET NOT NULL;


--SELECT count(*) FROM game_stats;


