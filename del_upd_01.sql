SELECT * FROM player_participation;
SELECT * FROM chess_player;
SELECT * FROM tournament;
SELECT * FROM game;

--пользуюсь следующим:
--Операторы, изменяющие данные в WITH, выполняются только один раз и всегда полностью, 
--                  вне зависимости от того, принимает ли их результат основной запрос.

WITH delete_player AS --один из участников не смог играть в турнире который проходит сегодня, удаляем его, возвращаем id этого турнира
(
	DELETE FROM player_participation
	WHERE 
	tournament_id = (SELECT tournament_id FROM tournament WHERE tournament_name = 'NOT REAL T2020 1') AND
	player_id = (SELECT player_id FROM chess_player WHERE first_name = 'NOT_REAL' AND second_name = '3')
	--RETURNING tournament_id AS t_id --if player was already delete from participation then it doesn't work  (*1)
),
t_tour_id AS --cause (*1) we need in it / and we can't make with in with cause 'предложение WITH, содержащее оператор, изменяющий данные, должно быть на верхнем уровне'
(	
	SELECT tournament_id AS t_id FROM tournament WHERE tournament_name = 'NOT REAL T2020 1'
),
win_sec_ids AS --раньше надо было выяснить кто из 3-х участников выйграет, так как теперь участника два, они играют, получаем их id 
(
	UPDATE game 
	SET player_1_points = 2.5, player_2_points = 1.5  
	WHERE
	participating_id_1 = 
		(
		SELECT player_participation_id FROM player_participation t_pp JOIN chess_player t_cp
		ON t_pp.player_id = t_cp.player_id 
		AND (first_name = 'NOT_REAL' AND second_name = '4') 
		AND tournament_id = (SELECT * FROM t_tour_id)
		)
	AND 
	participating_id_2 = 
		(
		SELECT player_participation_id FROM player_participation t_pp JOIN chess_player t_cp
		ON t_pp.player_id = t_cp.player_id 
		AND (first_name = 'NOT_REAL' AND second_name = '5') 
		AND tournament_id = (SELECT * FROM t_tour_id)
		)
	RETURNING 
		CASE 
	    WHEN player_1_points >= player_2_points THEN participating_id_1
		WHEN player_2_points > player_1_points THEN participating_id_2
		END AS winner_id, 
		CASE 
	    WHEN player_1_points < player_2_points THEN participating_id_1
		WHEN player_2_points <= player_1_points THEN participating_id_2
		END AS second_place_id
	--!! WHEN pp_1 = pp_2  p1 is winner 
),
winner_pp AS --обновляем информацию о победителе 
(
	UPDATE player_participation 
	SET place_in_standings = 1, rating_change = 15
	WHERE player_participation_id = (SELECT winner_id FROM win_sec_ids)
	RETURNING tournament_id, player_id, rating_change
),
second_pp AS --обновляем информацию о человеке который занял второе место
(
	UPDATE player_participation 
	SET place_in_standings = 2, rating_change = -5
	WHERE player_participation_id = (SELECT second_place_id FROM win_sec_ids)
	RETURNING tournament_id, player_id, rating_change
),
winner_p_id AS --изменяем рэйтинг победителя
(
	UPDATE chess_player  
	SET rating = rating + (SELECT rating_change FROM winner_pp)
	WHERE player_id = (SELECT player_id FROM winner_pp)
	RETURNING player_id AS p_id
),
second_p_id AS --изменяем рэйтинг участника заневшего 2-ое место
(
	UPDATE chess_player  
	SET rating = rating + (SELECT rating_change FROM second_pp)
	WHERE player_id = (SELECT player_id FROM second_pp)
	RETURNING player_id AS p_id
)
UPDATE tournament --добовляем в турнир информацию о победителе 
SET winner_id = (SELECT p_id FROM winner_p_id)
WHERE tournament_id = (SELECT * FROM t_tour_id);








SELECT * FROM game;

UPDATE player_participation
SET rating_change = 16
WHERE 
tournament_id = (SELECT tournament_id FROM tournament WHERE tournament_name = 'NOT REAL T2019 2') AND
player_id = (SELECT player_id FROM chess_player WHERE first_name = 'NOT_REAL' AND second_name = '2');

SELECT * FROM player_participation ORDER BY rating_change DESC;

SELECT * FROM chess_player;