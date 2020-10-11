--second run: 

--#1:
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
	--it not will done while other transaction not commited
	UPDATE player_participation SET rating_change = rating_change + 1 WHERE player_id = 25 AND tournament_id = 7;
	
	--while another transaction not complete it will return 'NOT REAL', '1'
	--after complite another transaction it will return 'REAL PLAYER', 'actually no'
	--thus dirty reading is not possible:
	SELECT first_name, second_name FROM chess_player WHERE player_id = 22; 
COMMIT;

--#2:
--the same behavior as READ UNCOMMITTED:
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED; 
	SELECT first_name, second_name FROM chess_player WHERE player_id = 22; 
	UPDATE player_participation SET rating_change = rating_change + 1 WHERE player_id = 25 AND tournament_id = 7;
	--неповторяемое чтение:
	SELECT first_name, second_name FROM chess_player WHERE player_id = 22; 
	--will update after parallel transaction commite: (фантомное чтение)
	SELECT * FROM game WHERE participating_id_1 = 1;
COMMIT;


--#3:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	--неповторяемое чтение невозможно
	SELECT first_name, second_name FROM chess_player WHERE player_id = 22;
	--фантомное чтение невозможно
	--after other transaction commit it all the same return value that was in BEGIN
	SELECT * FROM game WHERE participating_id_1 = 1;
	SELECT COUNT(*) FROM player_participation WHERE rating_change = 16;
COMMIT;


--#4:
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	SELECT count(*) FROM game WHERE participating_id_2 = 8;
	INSERT INTO game VALUES (1, 4, 1.5, 0.5, '25.09.2019', 3);--not real
COMMIT;--there will error


--#5:
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	SELECT count(*) FROM game WHERE participating_id_2 = 8;
	INSERT INTO game VALUES (1, 4, 1.5, 0.5, '25.09.2019', 3);--not real
COMMIT;--there not will error






