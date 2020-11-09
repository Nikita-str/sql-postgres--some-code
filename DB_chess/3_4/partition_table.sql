ERROR(KKKKkk)

DROP TABLE IF EXISTS part_game_stats;
CREATE TABLE part_game_stats (
	game_stat_id SERIAL,
	game_result SMALLINT[], 
	game_duration INTERVAL[],  
	viewer_amount INT[], 
	player_1_id INT,
	player_2_id INT,
	p1_rating INT,
	p2_rating INT,
	game_date DATE,
	tour_id INT 
) PARTITION BY RANGE (game_date);

/*
def pgs_create_tables(start_year, end_year):
	a = start_year; b = end_year;
	ind = a
	while (ind < b):
		print("CREATE TABLE  pgs_"+str(ind)+"_"+str(ind+3)+" PARTITION OF part_game_stats")
		print("    FOR VALUES FROM ('01.01."+str(ind)+"') TO ('01.01."+str(ind+3)+"');")
		print()
		ind+=3
*/

CREATE TABLE  pgs_2000  PARTITION OF part_game_stats FOR VALUES FROM ('01.01.0001') TO ('01.01.2000');

CREATE TABLE  pgs_2000_2003 PARTITION OF part_game_stats
    FOR VALUES FROM ('01.01.2000') TO ('01.01.2003');

CREATE TABLE  pgs_2003_2006 PARTITION OF part_game_stats
    FOR VALUES FROM ('01.01.2003') TO ('01.01.2006');

CREATE TABLE  pgs_2006_2009 PARTITION OF part_game_stats
    FOR VALUES FROM ('01.01.2006') TO ('01.01.2009');

CREATE TABLE  pgs_2009_2012 PARTITION OF part_game_stats
    FOR VALUES FROM ('01.01.2009') TO ('01.01.2012');

CREATE TABLE  pgs_2012_2015 PARTITION OF part_game_stats
    FOR VALUES FROM ('01.01.2012') TO ('01.01.2015');

CREATE TABLE  pgs_2015_2018 PARTITION OF part_game_stats
    FOR VALUES FROM ('01.01.2015') TO ('01.01.2018');

CREATE TABLE  pgs_2018_2021 PARTITION OF part_game_stats
    FOR VALUES FROM ('01.01.2018') TO ('01.01.2021');

CREATE TABLE  pgs_2021_2024 PARTITION OF part_game_stats
    FOR VALUES FROM ('01.01.2021') TO ('01.01.2024');

CREATE TABLE  pgs_2024_2027 PARTITION OF part_game_stats
    FOR VALUES FROM ('01.01.2024') TO ('01.01.2027');

CREATE TABLE  pgs_2027_2030 PARTITION OF part_game_stats
    FOR VALUES FROM ('01.01.2027') TO ('01.01.2030');

COPY part_game_stats FROM 'C:/OtherPrograms/For_DB/gm_stat#1000000.txt' DELIMITER ';';

/*
def a(b, c):
	i = c
	print("    IF (DATE '01.01."+str(i-3)+"' <= NEW.game_date AND")
	print("         NEW.game_date < DATE '01.01."+str(i)+"' ) THEN")
	print("        INSERT INTO pgs_"+str(i-3)+"_"+str(i)+" VALUES (NEW.*);")
	i -= 3
	while(i >= b):
		print("    ELSIF (DATE '01.01."+str(i-3)+"' <= NEW.game_date AND")
		print("         NEW.game_date < DATE '01.01."+str(i)+"' ) THEN")
		print("        INSERT INTO pgs_"+str(i-3)+"_"+str(i)+" VALUES (NEW.*);")
		i -= 3
	print("    ELSE RAISE EXCEPTION 'нужно создать таблицу pgs_year_yaer для соотв. года и изменить pgs_insert функцию'")
	print("    END IF;")
	print("    RETURN NULL;")
*/
/*
CREATE OR REPLACE FUNCTION pgs_insert()
RETURNS TRIGGER 
AS $$
BEGIN
    IF (DATE '01.01.2027' <= NEW.game_date AND
         NEW.game_date < DATE '01.01.2030' ) THEN
        INSERT INTO pgs_2027_2030 VALUES (NEW.*);
    ELSIF (DATE '01.01.2024' <= NEW.game_date AND
         NEW.game_date < DATE '01.01.2027' ) THEN
        INSERT INTO pgs_2024_2027 VALUES (NEW.*);
    ELSIF (DATE '01.01.2021' <= NEW.game_date AND
         NEW.game_date < DATE '01.01.2024' ) THEN
        INSERT INTO pgs_2021_2024 VALUES (NEW.*);
    ELSIF (DATE '01.01.2018' <= NEW.game_date AND
         NEW.game_date < DATE '01.01.2021' ) THEN
        INSERT INTO pgs_2018_2021 VALUES (NEW.*);
    ELSIF (DATE '01.01.2015' <= NEW.game_date AND
         NEW.game_date < DATE '01.01.2018' ) THEN
        INSERT INTO pgs_2015_2018 VALUES (NEW.*);
    ELSIF (DATE '01.01.2012' <= NEW.game_date AND
         NEW.game_date < DATE '01.01.2015' ) THEN
        INSERT INTO pgs_2012_2015 VALUES (NEW.*);
    ELSIF (DATE '01.01.2009' <= NEW.game_date AND
         NEW.game_date < DATE '01.01.2012' ) THEN
        INSERT INTO pgs_2009_2012 VALUES (NEW.*);
    ELSIF (DATE '01.01.2006' <= NEW.game_date AND
         NEW.game_date < DATE '01.01.2009' ) THEN
        INSERT INTO pgs_2006_2009 VALUES (NEW.*);
    ELSIF (DATE '01.01.2003' <= NEW.game_date AND
         NEW.game_date < DATE '01.01.2006' ) THEN
        INSERT INTO pgs_2003_2006 VALUES (NEW.*);
    ELSIF (DATE '01.01.2000' <= NEW.game_date AND
         NEW.game_date < DATE '01.01.2003' ) THEN
        INSERT INTO pgs_2000_2003 VALUES (NEW.*);
    ELSIF (NEW.game_date < DATE '01.01.2000') THEN
        INSERT INTO pgs_2000 VALUES (NEW.*);
    ELSE RAISE EXCEPTION 'нужно создать таблицу pgs_year_yaer для соотв. года и изменить pgs_insert функцию';
    END IF;
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;
*/
/*
CREATE TRIGGER trigger_pgs_insert
    BEFORE INSERT ON part_game_stats
    FOR EACH ROW EXECUTE FUNCTION pgs_insert(); 
*/	




