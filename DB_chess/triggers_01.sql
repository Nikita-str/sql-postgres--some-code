 
CREATE OR REPLACE FUNCTION check_valid_game() 
RETURNS TRIGGER AS $$ 
DECLARE
	var_tournament_id  INTEGER;
	
	var_tournament_date_start  DATE;	
	var_tournament_date_end    DATE;
	var_game_date DATE;
	
	var_round SMALLINT;
	var_tournament_rounds SMALLINT;
BEGIN
	var_tournament_id = (SELECT tournament_id FROM player_participation t_pp WHERE t_pp.player_participation_id = NEW.participating_id_1);
	IF --validate that it is the same tournament
		var_tournament_id
		<>
		(SELECT tournament_id FROM player_participation t_pp WHERE t_pp.player_participation_id = NEW.participating_id_2)
		THEN
		BEGIN
			RAISE EXCEPTION 'both players must play in the same tournament (element: %)', NEW;
		END;
	END IF;
	
	var_game_date = NEW.game_date;
	var_tournament_date_start = (SELECT date_start FROM tournament WHERE tournament_id = var_tournament_id);
	var_tournament_date_end   = (SELECT date_end   FROM tournament WHERE tournament_id = var_tournament_id);
	IF --validate date of game
		(var_game_date > var_tournament_date_end) OR (var_game_date < var_tournament_date_start) 
		THEN
		BEGIN
			RAISE EXCEPTION 'not valid date of game: % must be in [% ... %] (element: %)', 
							var_game_date, var_tournament_date_start, var_tournament_date_end, NEW;
		END;
	END IF;
	
	var_round = NEW.round;
	var_tournament_rounds = (SELECT total_rounds FROM tournament WHERE tournament_id = var_tournament_id);
	IF --validate game round
		(var_round > var_tournament_rounds)
		THEN
		BEGIN
			RAISE EXCEPTION 'not valid round of game: % must be in [1 ... %] (element: %)', 
							var_round, var_tournament_rounds, NEW;
		END;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_check_valid_game ON game;
CREATE TRIGGER trigger_check_valid_game
BEFORE INSERT OR UPDATE
ON game
FOR EACH ROW
EXECUTE FUNCTION check_valid_game();

--check tour:
--INSERT INTO game VALUES (1, 41, NULL, NULL, '05.10.2020', 1);--must be error

--check date:
--INSERT INTO game VALUES (2, 5, NULL, NULL, '08.09.2019', 4);--must be error (cause game_date < date_start)
--INSERT INTO game VALUES (2, 5, NULL, NULL, '09.09.2019', 4);--must be ok
--INSERT INTO game VALUES (2, 5, NULL, NULL, '05.10.2019', 4);--must be error (cause game_date > date_end)
--INSERT INTO game VALUES (2, 5, NULL, NULL, '04.10.2019', 4);--must be ok

--check round:
--INSERT INTO game VALUES (2, 5, NULL, NULL, '04.10.2019', 8);--must be error
--INSERT INTO game VALUES (2, 5, NULL, NULL, '04.10.2019', 7);--must be ok


--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

 
CREATE OR REPLACE FUNCTION set_if_need_winner() 
RETURNS TRIGGER AS $$ 
DECLARE
	var_place INTEGER;
	var_tournament_id  INTEGER;
BEGIN
	var_place = NEW.place_in_standings;
	IF (var_place IS NULL) OR (var_place <> 1) THEN BEGIN RETURN NEW; END; END IF; --go next only if this is winner
	
	var_tournament_id = NEW.tournament_id;
	UPDATE tournament -- set winner in tournament
	SET winner_id = NEW.player_id
	WHERE tournament_id = var_tournament_id;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_winner ON player_participation;
CREATE TRIGGER trigger_winner
BEFORE INSERT OR UPDATE
ON player_participation
FOR EACH ROW
EXECUTE FUNCTION set_if_need_winner();

/*
SELECT winner_id FROM tournament WHERE tournament_name LIKE 'N% R% T%20 1'; -- null
UPDATE player_participation SET place_in_standings = 1 WHERE player_id = 24;
SELECT winner_id FROM tournament WHERE tournament_name LIKE 'N% R% T%20 1'; -- 24
*/


--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

 
CREATE OR REPLACE FUNCTION change_player_rating() 
RETURNS TRIGGER AS $$ 
DECLARE
	var_rating_delta INTEGER;
	var_player_id  INTEGER;
BEGIN
	var_rating_delta = COALESCE(NEW.rating_change, 0);
	IF (COALESCE(OLD.rating_change, 0) = 0) AND (var_rating_delta = 0) 
		THEN BEGIN RETURN NEW; END;
	END IF; 
	
	var_player_id = NEW.player_id;
	UPDATE chess_player -- set winner in tournament
	SET rating = rating + var_rating_delta - COALESCE(OLD.rating_change, 0)
	WHERE player_id = var_player_id;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_change_player_rating ON player_participation;
CREATE TRIGGER trigger_change_player_rating
BEFORE INSERT OR UPDATE
ON player_participation
FOR EACH ROW
EXECUTE FUNCTION change_player_rating();

/*
SELECT rating FROM chess_player WHERE player_id = 25; -- x
UPDATE player_participation SET rating_change = 12 WHERE player_id = 25 AND tournament_id = 7;
SELECT rating FROM chess_player WHERE player_id = 25; -- x+12
UPDATE player_participation SET rating_change = 10 WHERE player_id = 25 AND tournament_id = 7;
SELECT rating FROM chess_player WHERE player_id = 25; -- x+10
UPDATE player_participation SET rating_change = NULL WHERE player_id = 25 AND tournament_id = 7;
SELECT rating FROM chess_player WHERE player_id = 25; -- x
UPDATE player_participation SET rating_change = 5 WHERE player_id = 25 AND tournament_id = 7;
SELECT rating FROM chess_player WHERE player_id = 25; -- x+5
*/
