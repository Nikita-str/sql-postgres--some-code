/*
WITH RECURSIVE t_1 AS
(
SELECT *, 1 AS x FROM (VALUES (2791, 'GM', 'Ding', 'Liren', 'CHN', '24 October 1992'::date)) AS tt(c_1, c_2, c_3, c_4, c_5, c_6)
UNION
SELECT c_1, c_2, c_3, c_4, c_5, c_6, x+1 AS x FROM t_1
	WHERE x < 100
)
INSERT INTO chess_player(rating, chess_title, first_name, second_name, country, birthday)
SELECT c_1, c_2, c_3, c_4, c_5, c_6 FROM t_1;
--adding 100 players
*/
--SELECT COUNT(player_id) FROM chess_player;

/*
WITH RECURSIVE t_1 AS
(
SELECT * FROM (VALUES (1, 25, FLOOR(1 + 14*RANDOM())::INT)) AS tt(c1, c2, c3)
UNION
SELECT c1, (c2 + 1) AS c2, FLOOR(1 + 14*RANDOM())::INT AS c3 FROM t_1
	WHERE c2 < 110
)
INSERT INTO player_participation(tournament_id, player_id, place_in_standings)
SELECT c1, c2, c3 FROM t_1;
*/
--SELECT COUNT(player_participation_id) FROM player_participation;

/*
WITH RECURSIVE t_1 AS
(
SELECT * FROM (VALUES (140, 141, FLOOR(3*RANDOM())::INT, FLOOR(3*RANDOM())::INT, '24 October 2012'::date, FLOOR(1 + 5*RANDOM())::INT)) AS tt(c1, c2, c3, c4, c5, c6)
UNION
SELECT (c1 + 1) AS c1, (c2 + 1) AS c2, FLOOR(3*RANDOM())::INT, FLOOR(3*RANDOM())::INT, '24 October 2012'::date, FLOOR(1 + 5*RANDOM())::INT FROM t_1
	WHERE c2 < 220
)
INSERT INTO game
SELECT * FROM t_1;
*/
--SELECT COUNT(round) FROM game;

WITH max_GM_birth_months AS --самые частые месяца рождения гроссмейстеров (т.е. например, одинаковое количество гроссмейстеров может родится в октябрь и ноябрь)
(
	WITH max_GM_birth_month_count AS
		(
		SELECT COUNT(EXTRACT(MONTH FROM birthday)) max_count FROM chess_player 
		WHERE chess_title = 'GM'
		GROUP BY EXTRACT(MONTH FROM birthday)
		ORDER BY 1 DESC 
		LIMIT 1
		)
	SELECT EXTRACT(MONTH FROM birthday) max_date FROM chess_player
	GROUP BY EXTRACT(MONTH FROM birthday)
	HAVING COUNT(EXTRACT(MONTH FROM birthday)) = (TABLE max_GM_birth_month_count)
	--cause max months may be more than one
)
SELECT player_id /* * */ FROM chess_player
WHERE EXTRACT(MONTH FROM birthday) IN (TABLE max_GM_birth_months)
ORDER BY rating DESC;


SELECT DISTINCT t_cp.* /*player_id*/ FROM chess_player t_cp, player_participation t_pp, game t_g
WHERE (t_cp.player_id = t_pp.player_id) AND 
(player_participation_id = participating_id_1 OR player_participation_id = participating_id_2) AND
(
	(EXTRACT(MONTH FROM birthday) = EXTRACT(MONTH FROM game_date)) AND 
	(EXTRACT(DAY FROM birthday) = EXTRACT(DAY FROM game_date))
);
--игроки игравшие в свой день рождения

WITH tur_id AS
	(
	SELECT tournament_id FROM tournament
	WHERE (EXTRACT(YEAR FROM date_start) = 2019) AND (EXTRACT(YEAR FROM date_end) = 2019)  
	),
winner_id AS
	(
	SELECT 
		CASE 
			WHEN player_1_points > player_2_points THEN participating_id_1 
			WHEN player_2_points > player_1_points THEN participating_id_2
			END
		AS round_winner_id FROM game 
		WHERE player_1_points <> player_2_points 
	), 
player_win_in_one_tour2019_more_3_times AS
	(
	SELECT player_id FROM winner_id JOIN player_participation
		ON tournament_id IN (TABLE tur_id) AND player_participation_id = round_winner_id
		GROUP BY player_participation_id
		HAVING COUNT(round_winner_id) >= 3
	)
SELECT DISTINCT first_name, second_name FROM chess_player t_cp JOIN player_win_in_one_tour2019_more_3_times t_w
ON t_cp.player_id = t_w.player_id;
--имена (имя-фамилия) игроков которые победили в любом турнире, из проходивших в 2019 году, 3 и более противников 
--(имеется в виду, что если игрок победил два раза в одном турнире 2019 года и 2 раза в другом (в сумме 4), то его НЕ включаем в список)


WITH wl_id AS
	(
	SELECT 
		CASE 
			WHEN player_1_points > player_2_points THEN participating_id_1 
			WHEN player_2_points > player_1_points THEN participating_id_2
			END
		AS winner_id,
		CASE 
			WHEN player_1_points < player_2_points THEN participating_id_1 
			WHEN player_2_points < player_1_points THEN participating_id_2
			END
		AS loser_id 
		FROM game 
		WHERE player_1_points <> player_2_points 
	), 
wl_player_id AS
	(
	SELECT t_pp_1.player_id AS w_player_id, t_pp_2.player_id AS l_player_id 
	FROM wl_id, player_participation t_pp_1, player_participation t_pp_2
	WHERE winner_id = t_pp_1.player_participation_id AND loser_id = t_pp_2.player_participation_id
	/*
	SELECT w_player_id, l_player_id FROM 
		(SELECT player_id AS w_player_id, winner_id, loser_id FROM wl_id JOIN player_participation ON winner_id = player_participation_id) T_w
		NATURAL JOIN
		(SELECT winner_id, loser_id, player_id AS l_player_id FROM wl_id JOIN player_participation ON loser_id = player_participation_id) T_l	
	*/
	)
SELECT t_cp_1.* FROM chess_player t_cp_1, chess_player t_cp_2, wl_player_id t_wlp
WHERE w_player_id = t_cp_1.player_id AND l_player_id = t_cp_2.player_id AND t_cp_1.rating < t_cp_2.rating
GROUP BY t_cp_1.player_id
HAVING COUNT(w_player_id) >= 2;
--информация об игроках обыгравших людей с рейтингом больше чем у них 2 и более раз
 

SELECT player_id, rating_change, SUM(rating_change) OVER (PARTITION BY player_id ORDER BY (date_end))
FROM player_participation t_pp JOIN tournament t_t ON t_pp.tournament_id = t_t.tournament_id;









--найти самый частый месяц рождения игроков
--найти игроков игравших в свой день рождения
--имена (имя-фамилия) игроков которые победили в турнирах, проводившихся в 2019 году, 3 и более раз
--имена игроков обыгравших людей с рейтингом больше чем у них

