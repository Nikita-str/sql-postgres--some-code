INSERT INTO chess_title
VALUES ('NONE','NONE'), ('GM', 'Grandmaster'), ('IM', 'International Master'), ('FM', 'FIDE Master'), ('CM', 'Candidate Master');

INSERT INTO chess_player(rating, chess_title, first_name, second_name, country, birthday)
VALUES
--CWC 2019:
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
(2696, 'GM', 'Kirill', 'Alekseenko', 'RUS', '22 June 1997'),
----- + CWC 2017:
(2678, 'GM', 'Vasyl', 'Ivanchuk', 'UKR', 'March 18, 1969'),
(2678, 'GM', 'Vladimir', 'Fedoseev', 'RUS', 'February 16, 1995'),--yes, the same rank now
(2760, 'GM', 'Richárd', 'Rapport', 'HUN', '25 March 1996'),
----- + CT 2018:
(2835, 'GM', 'Fabiano', 'Caruana', 'USA', 'July 30, 1992'),
(2752, 'GM', 'Sergey', 'Karjakin', 'USA', '12 January 1990'),
----- + NOT REAL:
(2800, 'GM', 'NOT_REAL', '1', 'RUS', '09.09.1999'),
(2650, 'IM', 'NOT_REAL', '2', 'RUS', '19.03.1993'),
(2750, 'GM', 'NOT_REAL', '3', 'RUS', '02.01.2000'),
(2620, 'IM', 'NOT_REAL', '4', 'RUS', '07.08.1999'),
(2670, 'IM', 'NOT_REAL', '5', 'RUS', '05.03.1990');

--SELECT * FROM chess_player;

INSERT INTO organizator(organizator_name, site_link, phone_number)
VALUES
('FIDE', 'https://www.fide.com/', '+ (41) 21 6010039'), 
('Agon Limited', NULL, NULL),
-------NOT REAL!:
('Your Imagination', 'https://en.wikipedia.org/wiki/Imagination', '+0 (000) 000-00-00');

/*
DELETE FROM organizator WHERE site_link IS NULL;
SELECT * FROM organizator;
SELECT * FROM tournament;
*/

INSERT INTO tournament_category
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
	),
	('Candidates Tournament 2018', NULL, 'FIDE XXII',
	 7, '10 March 2018', '28 March 2018', 
	 'DEU', 'Berlin', 2, 20
	),
	--NOT REAL:
	('NOT REAL T2019 1', 'imagination://T2019_1.not_real.com/', 'FIDE XX',
	 7, '10.07.2019', '11.08.2019', 
	 'LIE', 'Deception', 3, 22
	),
	('NOT REAL T2019 2', 'imagination://T2019_2.not_real.com/', 'FIDE XX',
	 7, '15.08.2019', '21.09.2019', 
	 'LIE', 'Deception', 3, 24
	),
	('NOT REAL T2019 3', 'imagination://T2019_3.not_real.com/', 'FIDE XX',
	 7, '23.11.2019', '05.01.2020', 
	 'LIE', 'Deception', 3, 23
	),
	('NOT REAL T2020 1', 'imagination://T2020_1.not_real.com/', 'FIDE XIX',
	 1, '01.10.2020', '05.10.2020', 
	 'LIE', 'Deception', 3, NULL
	);
	
INSERT INTO player_participation(tournament_id, player_id, place_in_standings) 
VALUES
	(1, 1, 2),
	(1, 2, 1),
	(1, 3, 4),
	(1, 4, 3),
	(1, 5, 5),
	(1, 6, 5),
	(1, 7, 5),
	(1, 8, 5),
	(1, 9, 9),
	(1, 10, 9),
	(1, 11, 9),
	(1, 12, 9),
	(1, 13, 9),
	(1, 14, 9),
	(1, 15, 9),
	(1, 16, 9),
	-----------
	(2, 7, 1),
	(2, 1, 2),
	(2, 4, 3),
	(2, 13, 4),
	(2, 12, 5),
	(2, 17, 5),
	(2, 18, 5),
	(2, 19, 5),
	-----------
	(3, 20, 1),
	(3, 10, 2),
	(3, 21, 3),
	(3, 1, 4),
	-----------NOT REAL !:
	(4, 22, 1),
	(4, 23, 2),
	(4, 24, 3),
	(4, 25, 4),
	---
	(5, 23, 2),
	(5, 24, 1),
	(5, 25, 3),
	(5, 26, 4),
	--
	(6, 23, 1),
	(6, 24, 2),
	--
	(7, 25, NULL),
	(7, 26, NULL),
	(7, 24, NULL);
	
SELECT * FROM player_participation;
SELECT * FROM chess_player;
	
INSERT INTO game 
VALUES
	--- CWC 2019:
	(1, 2, 4, 6, '30.09.2019', 7),
	(3, 4, 2, 4, '30.09.2019', 7),
	(1, 3, 2.5, 1.5, '26.09.2019', 6),
	(2, 4, 1.5, 0.5, '26.09.2019', 6),
	(1, 5, 1.5, 0.5, '23.09.2019', 5),
	(3, 6, 5, 4, '23.09.2019', 5),
	(4, 7, 2.5, 1.5, '23.09.2019', 5),
	(2, 8, 1.5, 0.5, '23.09.2019', 5),
	(8, 9, 4.5, 3.5, '20.09.2019', 4),
	(2, 10, 3.5, 2.5, '20.09.2019', 4),
	(7, 11, 3.5, 2.5, '20.09.2019', 4),
	(4, 12, 1.5, 0.5, '20.09.2019', 4),
	(6, 13, 1.5, 0.5, '20.09.2019', 4),
	(3, 14, 1.5, 0.5, '20.09.2019', 4),
	(5, 15, 2.5, 1.5, '20.09.2019', 4),
	(1, 16, 3, 1, '20.09.2019', 4),
	-----CWC 2017:
	(17, 18, 4, 2, '22.09.2017', 7),
	(17, 19, 5, 4, '20.09.2017', 6),
	(18, 20, 3.5, 2.5, '20.09.2017', 6),
	(19, 21, 2.5, 1.5, '17.09.2017', 5),
	(17, 22, 1.5, 0.5, '17.09.2017', 5),
	(20, 23, 1.5, 0.5, '17.09.2017', 5),
	(18, 24, 1.5, 0.5, '17.09.2017', 5),
	-----CT 2018:
	(25, 26, 0.5, 0.5, '12.03.2018', 5),
	(25, 27, 1.5, 0.5, '24.03.2018', 5),
	(25, 28, 0.5, 0.5, '11.03.2018', 5),
	(26, 27, 1, 0.5, '19.03.2018', 5),
	(26, 28, 0.5, 0, '24.03.2018', 5),
	(27, 28, 0.5, 0.5, '27.03.2018', 5),
	----NOT REAL:
	(2, 3, 1.5, 1.5, '09.09.2019', 4), -- BIRTH DAY = GAME_DATE
	----NOT_REAL 1:
	(29, 30, 1.5, 0.5, '10.08.2019', 5),
	(29, 31, 2.5, 1.5, '23.07.2019', 4),
	(29, 32, 0.5, 0.5, '21.07.2019', 3), -- if so then 29(p_id=22) has only 2 win
	(30, 31, 2.5, 1.5, '22.07.2019', 4),-- 30 : p_id = 23
	(30, 32, 1.5, 0.5, '14.07.2019', 3),
	----NOT_REAL 2:
	(33, 34, 0.5, 1.5, '10.09.2019', 5),
	(34, 35, 2.5, 1.5, '23.08.2019', 4),
	(34, 36, 1.5, 0.5, '21.08.2019', 3), -- 34(player_id = 24) has 3 win
	(33, 35, 2.5, 1.5, '22.08.2019', 4), -- 33 : p_id = 23
	(33, 36, 2.5, 0.5, '16.08.2019', 3),
	----NOT_REAL 3:
	(37, 38, 2.5, 0.5, '01.01.2020', 6),-- so player with id = 23 has 3 win player with rank more than his
	----NOT REAL 2020 1:
	(39, 40, NULL, NULL, '05.10.2020', 1),
	(39, 41, NULL, NULL, '05.10.2020', 1),
	(40, 41, NULL, NULL, '05.10.2020', 1);
	--(1, 41, NULL, NULL, '05.10.2020', 1);--TODO:must ERROR