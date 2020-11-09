--first run:

--#1:
BEGIN /*; SET*/ TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- the same as READ COMMITED 
	UPDATE player_participation SET rating_change = rating_change + 1 WHERE player_id = 25 AND tournament_id = 7;
	UPDATE chess_player 
	SET first_name = 'REAL PLAYER', second_name = 'actually no' 
	WHERE player_id = 22;
COMMIT;

--#2:
UPDATE player_participation SET rating_change = 0 WHERE player_id = 25 AND tournament_id = 7;
UPDATE chess_player SET first_name = 'NOT REAL', second_name = '1' WHERE player_id = 22;

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SELECT * FROM chess_player WHERE FALSE; -- just for alignment of operation | return nothing
	UPDATE chess_player 
	SET first_name = 'REAL PLAYER', second_name = 'actually no' 
	WHERE player_id = 22;
	UPDATE player_participation SET rating_change = rating_change + 1 WHERE player_id = 25 AND tournament_id = 7;
	INSERT INTO game VALUES (1, 4, 1.5, 0.5, '25.09.2019', 2);--not real
COMMIT;

--#3:
UPDATE player_participation SET rating_change = 0 WHERE player_id = 25 AND tournament_id = 7;
UPDATE chess_player SET first_name = 'NOT REAL', second_name = '1' WHERE player_id = 22;
DELETE FROM game WHERE participating_id_1 = 1 AND participating_id_2 = 4;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	UPDATE chess_player SET first_name = 'REAL PLAYER', second_name = 'actually no' WHERE player_id = 22;
	INSERT INTO game VALUES (1, 4, 1.5, 0.5, '25.09.2019', 2);--not real
	UPDATE player_participation SET rating_change = rating_change * 2 WHERE player_id = 25 AND tournament_id = 7;
COMMIT;

--#4:
UPDATE player_participation SET rating_change = 8 WHERE player_id = 25 AND tournament_id = 7;
UPDATE chess_player SET first_name = 'NOT REAL', second_name = '1' WHERE player_id = 22;
DELETE FROM game WHERE participating_id_1 = 1 AND participating_id_2 = 4;
DELETE FROM game WHERE participating_id_1 = 3 AND participating_id_2 = 8;
UPDATE player_participation SET rating_change = 2 WHERE player_id = 26 AND tournament_id = 7;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	SELECT count(*) FROM game WHERE participating_id_1 = 1;
	INSERT INTO game VALUES (3, 8, 1.5, 0.5, '25.09.2019', 3);--not real
COMMIT;

--#5:
DELETE FROM game WHERE participating_id_1 = 1 AND participating_id_2 = 4;
DELETE FROM game WHERE participating_id_1 = 3 AND participating_id_2 = 8;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	SELECT count(*) FROM game WHERE participating_id_1 = 1;
	INSERT INTO game VALUES (3, 8, 1.5, 0.5, '25.09.2019', 3);--not real
COMMIT;

--#6: DEAD LOCK:
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE NOT DEFERRABLE; --READ UNCOMMITTED;
	UPDATE chess_player SET first_name = first_name WHERE player_id = 1; -- 1
	UPDATE chess_player SET first_name = first_name WHERE player_id = 2; -- 4
COMMIT;

--TODO:USE OLD in rating_change trigger


-------------------------
UPDATE player_participation SET rating_change = 0 WHERE player_id = 25 AND tournament_id = 7;
UPDATE chess_player SET first_name = 'NOT REAL', second_name = '1' WHERE player_id = 22;

SELECT rating_change FROM player_participation WHERE player_id = 25 AND tournament_id = 7;
SELECT rating_change FROM player_participation WHERE player_id = 26 AND tournament_id = 7;
SELECT * FROM chess_player; 

SELECT * FROM game WHERE participating_id_1 = 1;
-------------------------
BEGIN;
	INSERT INTO tournament_category VALUES ();
	SAVEPOINT sp;
	INSERT INTO tournament_category VALUES ();
	ROLLBACK TO SAVEPOINT sp;
	INSERT INTO tournament_category VALUES ();
COMMIT;

