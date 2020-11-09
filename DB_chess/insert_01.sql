DELETE FROM chess_title WHERE TRUE;
INSERT INTO chess_title
VALUES ('NONE','NONE'), ('GM', 'Grandmaster'), ('IM', 'International Master'), ('FM', 'FIDE Master'), ('CM', 'Candidate Master');
SELECT * FROM chess_title;


DROP TABLE temp__cwc_2019_player_id;
CREATE TEMPORARY TABLE temp__cwc_2019_player_id (_id INTEGER UNIQUE);

DELETE FROM chess_player WHERE TRUE;
--INSERT INTO temp__cwc_2019_player_id(_id) SELECT * FROM
WITH _ids AS
(
INSERT INTO chess_player(rating, chess_title, first_name, second_name, country, birthday)
VALUES
--CWC 2019
(2791, 'GM', 'Ding', 'Liren', 'CHN', '24 October 1992'),
(2765, 'GM', 'Teimour', 'Radjabov', 'AZE', '12 March 1987'), --winner
(2709, 'GM', 'Yu', 'Yangyi', 'CHN', '8 June 1994'),
(2778, 'GM', 'Maxime', 'Vachier-Lagrave', 'FRA', '21 October 1990'),
(2777, 'GM', 'Alexander', 'Grischuk', 'RUS', 'October 31, 1983'),
(2722, 'GM', 'Nikita', 'Vitiugov', 'RUS', '4 February 1987'),
(2773, 'GM', 'Levon', 'Aronian', 'ARM', '6 October 1982'),
(2709, 'GM', 'Jeffery', 'Xiong', 'USA', 'October 30, 2000'),
(2753, 'GM', 'Jan-Krzysztof', 'Duda', 'POL', '26 April 1998'),
(2764, 'GM', 'Shakhriyar', 'Mamedyarov', 'AZE', '12 April 1985'),
(2709, 'GM', 'Lê Quang', 'Liêm', 'AZE', '13 March 1991'),
(2723, 'GM', 'Peter', 'Svidler', 'RUS', '17 June 1976'),
(2770, 'GM', 'Wesley', 'So', 'USA', 'October 9, 1993'),
(2784, 'GM', 'Ян', 'Непомнящий', 'RUS', '14 July 1990'),
(2758, 'GM', 'Leinier', 'Domínguez', 'USA', 'September 23, 1983'),
(2696, 'GM', 'Kirill', 'Alekseenko', 'RUS', '22 June 1997')
RETURNING player_id
)
INSERT INTO temp__cwc_2019_player_id SELECT * FROM _ids;
--
SELECT * FROM temp__cwc_2019_player_id;
SELECT * FROM chess_player;

DELETE FROM organizator WHERE TRUE;
INSERT INTO organizator(organizator_name, site_link, phone_number)
VALUES
('FIDE', 'https://www.fide.com/', '+ (41) 21 6010039'),
('Agon Limited', NULL, NULL);
SELECT * FROM organizator;

DELETE FROM tournament_category WHERE TRUE;
INSERT INTO tournament_category--(category_name, avg_min_rating, avg_max_rating) 
VALUES
('FIDE I', 2251, 2275),
('FIDE II', 2276, 2300),
('FIDE III', 2301, 2325),
('FIDE IV', 2326, 2350),
('FIDE V', 2351, 2375),
('FIDE VI', 2376, 2400),
('FIDE VII', 2401, 2425),	
('FIDE VIII', 2426, 2450),
('FIDE IX', 2451, 2475),
('FIDE X', 2476, 2500),
('FIDE XI', 2501, 2525),
('FIDE XII', 2526, 2550),
('FIDE XIII', 2551, 2575),
('FIDE XIV', 2576, 2600),
('FIDE XV', 2601, 2625),
('FIDE XVI', 2626, 2650),
('FIDE XVII', 2651, 2675),
('FIDE XVIII', 2676, 2700),
('FIDE XIX', 2701, 2725),
('FIDE XX', 2726, 2750),
('FIDE XXI', 2751, 2775),
('FIDE XXII', 2776, 2800),
('FIDE XXIII', 2801, 2825),
('By Selection Results', 0, NULL);
SELECT * FROM tournament_category;

DELETE FROM tournament WHERE TRUE;
INSERT INTO tournament(tournament_name, official_site, category, 
					   total_rounds, date_start, date_end, 
					   country, city, 
					   organizator_id, 
					   winner_id)
VALUES
	('Chess World Cup 2019', 'https://khantymansiysk2019.fide.com/', 'By Selection Results',
	 7, '9 September 2019', '4 October 2019', 
	 'RUS', 'Ханты-Мансийск', 
	(SELECT organizator_id FROM organizator WHERE organizator_name = 'FIDE'),
	(SELECT player_id FROM chess_player WHERE country = 'AZE' AND first_name = 'Teimour' AND second_name = 'Radjabov')
	),
	('Chess World Cup 2017', 'http://tbilisi2017.fide.com/', 'By Selection Results',
	 7, '2 September 2017', '27 September 2017', 
	 'GEO', 'Tbilisi', 
	(SELECT organizator_id FROM organizator WHERE organizator_name = 'FIDE'),
	(SELECT player_id FROM chess_player WHERE country = 'ARM' AND first_name = 'Levon' AND second_name = 'Aronian')
	)
RETURNING tournament_id;
SELECT * FROM tournament;

DELETE FROM player_participation WHERE TRUE;
INSERT INTO player_participation(tournament_id, player_id) SELECT 5, * FROM temp__cwc_2019_player_id;
--VALUES(5, NULL, 5, -3);
SELECT * FROM player_participation;

DELETE FROM game WHERE TRUE;
INSERT INTO game VALUES(1, 1, 1.5, 2, '09.09.2019', 3); 
SELECT * FROM game;


