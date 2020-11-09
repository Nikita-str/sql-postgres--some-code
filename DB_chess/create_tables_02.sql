DROP TABLE IF EXISTS game;
DROP TABLE IF EXISTS player_participation;
DROP TABLE IF EXISTS tournament;
DROP TABLE IF EXISTS organizator;
DROP TABLE IF EXISTS tournament_category;
DROP TABLE IF EXISTS chess_player;
DROP TABLE IF EXISTS chess_title;

--country table in other file! 

CREATE TABLE chess_title
	(
	title VARCHAR(8) PRIMARY KEY,
	full_name VARCHAR(80) NOT NULL UNIQUE
	);

CREATE TABLE chess_player
	(
	player_id SERIAL PRIMARY KEY,
	rating SMALLINT NOT NULL, -- ELO system -- in whole history didn't reach more than 2900 in chess, (for example in 'go' no more 3800 | in 'shogi' no more 2400)
	chess_title VARCHAR(8) REFERENCES chess_title(title) ON UPDATE CASCADE NOT NULL, 
	first_name VARCHAR(80) NOT NULL,
	second_name VARChAR(80) NOT NULL,
	country VARCHAR(4) REFERENCES table_country(country),
	birthday DATE,
	CONSTRAINT birthday_need_be_valid CHECK (birthday is NULL OR birthday < CAST(NOW() AS DATE)),
	CONSTRAINT rating_more_or_equal_zero CHECK (0 <= rating),
	CONSTRAINT len_of_name_more_than_zero CHECK (0 < LENGTH(first_name) AND 0 < LENGTH(second_name))
	);
	
CREATE TABLE organizator
	(
	organizator_id SERIAL PRIMARY KEY,
	organizator_name VARCHAR(120) NOT NULL,
	site_link TEXT, -- IE has a max len limit(2048), but in genereal there is no such limitation, so VARCHAR isn't suitable
	phone_number VARCHAR(24), -- "XXX X (XXXX) XXX-XX-XX" / "+XX X...X" / "+7 (XXX) XXX-XX-XX" / and so on...
	CONSTRAINT len_of_name_more_than_zero CHECK (0 < LENGTH(organizator_name))
	);

CREATE TABLE tournament_category
	(
	category_name VARCHAR(80) PRIMARY KEY, 
	avg_min_rating SMALLINT DEFAULT(0),	
	avg_max_rating SMALLINT, 
	CONSTRAINT max_must_be_more_than_min CHECK(avg_max_rating IS NULL OR avg_max_rating > avg_min_rating)
	);
	
CREATE TABLE tournament
	(
	tournament_id SERIAL PRIMARY KEY,
	tournament_name VARCHAR(160) NOT NULL, 
	official_site TEXT, -- q.v. organizator.site_link comment
	category VARCHAR(80) REFERENCES tournament_category(category_name) NOT NULL, 
	total_rounds SMALLINT, -- ~(2^(total_round+1) - 1) games
	date_start date NOT NULL,
	date_end date NOT NULL,
	country VARCHAR(4) REFERENCES table_country(country) NOT NULL,
	city VARCHAR(80) NOT NULL,
	organizator_id INTEGER REFERENCES organizator(organizator_id),
	winner_id INTEGER REFERENCES chess_player(player_id), 
	CONSTRAINT len_of_name_more_than_zero CHECK (0 < LENGTH(tournament_name)),
	CONSTRAINT valid_date CHECK (date_start <= date_end),
	CONSTRAINT valid_amount_of_round CHECK (total_rounds IS NULL OR total_rounds > 0)
	);
	
CREATE TABLE player_participation
	(
	player_participation_id /*BIG*/SERIAL PRIMARY KEY,--I'm not sure that there will never be 4 billion
	tournament_id INTEGER REFERENCES tournament(tournament_id) NOT NULL,
	player_id INTEGER REFERENCES chess_player(player_id) NOT NULL,
	place_in_standings INTEGER, --in principle, you can hold a tournament with more than 100,000 participants and do it in a reasonable time
	rating_change SMALLINT DEFAULT(0),
	CONSTRAINT player_cant_play_in_same_tournament_twice UNIQUE (tournament_id, player_id),
	CONSTRAINT valid_place CHECK (place_in_standings IS NULL OR place_in_standings > 0)
	--CONSTRAINT ??? UNIQUE (tournament_id, place_in_standing) -- in fact, when player_1 take 60th place by points and it do someone else, they don't play with each other, since it's no too important    
	);
	
CREATE TABLE game
	(
	participating_id_1 BIGINT REFERENCES player_participation(player_participation_id) ON DELETE CASCADE ON UPDATE CASCADE, --player can refuse to participation
	participating_id_2 BIGINT REFERENCES player_participation(player_participation_id) ON DELETE CASCADE ON UPDATE CASCADE,
	player_1_points NUMERIC(3,1),
	player_2_points NUMERIC(3,1),
	game_date date,
	round SMALLINT,
	CONSTRAINT player_dont_play_twice_against_each_other PRIMARY KEY(participating_id_1, participating_id_2), 	
	--CONSTRAINT player_dont_play_with_himself CHECK (participating_id_1 <> participating_id_2),
	CONSTRAINT player_must_be_sorted CHECK (participating_id_1 < participating_id_2),
	CONSTRAINT round_more_than_zero CHECK (round IS NULL OR round > 0),
	CONSTRAINT valid_points_p1 CHECK (player_1_points IS NULL OR player_1_points >= 0),
	CONSTRAINT valid_points_p2 CHECK (player_2_points IS NULL OR player_2_points >= 0)
	);