ERROR 
YOU
ARE 
SURE

BEGIN;
DROP TABLE IF EXISTS game_stats;
DROP TABLE IF EXISTS player_stats;
DROP TABLE IF EXISTS tour_stats;

CREATE TABLE player_stats
(
	player_stats_id SERIAL /*PRIMARY KEY*/,
	--rating (DATE, INT)[],
	--rating jsonb,
	rating_date DATE[], --> по этим штукам можно строить график, или, что скорее логичнее, посмотреть 'серию повышения рейтинга' 
	rating INT[], ---------^                             за игроками которые много игр подряд только повышают свой рейтинг наблюдают больше
	about_tactic TEXT, --> тут может быть информация благодоря которой игры становятся интересными и их смотрят, 
					   --  например есть выжидающие тактики, где игрок не рискует, ведет оборону и только в уверенных случаях атакует, 
	                   --  за такими играми зачастую скучно наблюдать
	player_info json --jsonb скорее всего нам нужны будут данные выше, а не эти
);

CREATE TABLE tour_stats --> самая маленькая таблица
(
	tour_id SERIAL /*PRIMARY KEY*/,
	tour_name TEXT,
	tour_year_start INT, --> впринципе нас интересует только анализ популярности шахмат (есть ли устойчивая динамика роста/падения по годам) 
	organizator_info jsonb --> таблица (по отношению к другим) маленькая и поэтому некоторая обработка на вставке нас не сильно волнует 
);

CREATE TABLE game_stats --> самая большая таблица
(
	game_stat_id SERIAL /*PRIMARY KEY*/,
	--в след. 3х строках имеется ввиду 'game' как партия:
	game_result SMALLINT[], --> 0: [1&2]+0.5; 1:[1]+1; -1:[2]+1;
	game_duration INTERVAL[], -- не json т.к. json увеличавает память  и тем более не jsonb т.к. это еще и увеличит время вставки, 
	viewer_amount INT[], 
	-->[after] теперь мы можем отследить зависимость смотрящих от результатов игр и от длитильности предыдущих партий,  
	--  	   это вполне можно использовать для понимания того в какх играх имеет смысл делать рекламу, и какую
	player_1_id INT /*REFERENCES player_stats(player_stats_id) NOT NULL*/,
	player_2_id INT /*REFERENCES player_stats(player_stats_id) NOT NULL*/,
	p1_rating INT, --> пользуемся денормализацией для ускорения | это не большие(4 байта) данные но поможет сохранить много времени(ссылка и поиск)
	p2_rating INT, --> пользуемся денормализацией для ускорения | т.е. это выгоднее хранить напрямую тут
	-->[after] также мы можем смотреть зависимость от самих игроков, т.е. понятно что за игроками с меньшим рэйтингом следят меньше болельщиков
	game_date DATE, --> с помощью даты мы можем узнать рэйтинг игроков в момент игры, 
	                --  в пределах одного матча рэйтинг не меняется, поэтому достаточно хранить дату первой партии
	                --  а даже если он меняется благодоря другому турниру(чего на практики вроде не встречается) 
	                --  то это не важно т.к. зименения не значительны
	tour_id INT /*REFERENCES tour_stats(tour_id)*/--> теперь ммы можем смотреть еще и зависимость от турнира / организатора
);
COMMIT;



