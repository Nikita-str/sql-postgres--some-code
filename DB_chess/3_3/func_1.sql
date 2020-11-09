
DROP MATERIALIZED VIEW IF EXISTS all_org_names;
CREATE MATERIALIZED VIEW all_org_names AS
SELECT DISTINCT organizator_info->>'o_name' FROM tour_stats;

CREATE OR REPLACE PROCEDURE check_valid_org(org_name TEXT)
AS $$
BEGIN
	IF (org_name NOT IN (TABLE all_org_names)) THEN
		RAISE EXCEPTION 'organizator not found [name = %]', org_name;
	END IF;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_org_tour_by_id(tour_id INT, OUT org_name TEXT)
AS $$
BEGIN
	SELECT organizator_info->>'o_name' FROM tour_stats WHERE tour_stats.tour_id = get_org_tour_by_id.tour_id INTO org_name;
	IF org_name IS NULL THEN 
		RAISE EXCEPTION 'id is invalid: %', tour_id;
	END IF;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_game_viewer_sum(viewer_amount INT[], OUT viewer_sum INT)
AS $$
BEGIN SELECT SUM(viewer) FROM UNNEST(viewer_amount) viewer INTO viewer_sum; END;
$$
LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION get_game_viewer_sum_2(viewer_amount INT[], OUT viewer_sum INT)
AS $$
DECLARE 
	var_x INT;
BEGIN 
	viewer_sum = 0;
	FOREACH var_x IN ARRAY viewer_amount LOOP
		viewer_sum = viewer_sum + var_x;
	END LOOP;
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS get_viewer_amount_of_org(text);
CREATE OR REPLACE FUNCTION get_viewer_amount_of_org(org_name TEXT, OUT viewer_amount BIGINT)
AS $$
DECLARE 
	var_oke_besih BIGINT;
BEGIN
	CALL check_valid_org(org_name);

	SELECT (SUM(sum_viewer))::BIGINT FROM tour_map_viewer JOIN tour_stats 
		ON tour_map_viewer.tour_id = tour_stats.tour_id AND tour_stats.organizator_info->>'o_name' = org_name
		INTO viewer_amount;
	
	RETURN;
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS which_org_is_better(text,text);
CREATE OR REPLACE FUNCTION which_org_is_better(org_name_1 TEXT, org_name_2 TEXT, OUT org_name TEXT, OUT viewer_delta BIGINT)
AS $$
DECLARE
	var_org_1_viewers BIGINT;
	var_org_2_viewers BIGINT;
BEGIN
	IF (org_name_1 = org_name_2) THEN 
		RAISE EXCEPTION 'organizers must have different names';
	END IF;
	CALL check_valid_org(org_name_1);
	CALL check_valid_org(org_name_2);	
	var_org_1_viewers = get_viewer_amount_of_org(org_name_1);
	var_org_2_viewers = get_viewer_amount_of_org(org_name_2);
	IF(var_org_1_viewers <var_org_2_viewers) THEN
		org_name = org_name_2;
		viewer_delta = var_org_2_viewers - var_org_1_viewers;
	ELSE 
		org_name = org_name_1;
		viewer_delta = var_org_1_viewers - var_org_2_viewers;
	END IF;
	RETURN;
END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_n_game_stats(how_much int, min_viewer int) 
RETURNS SETOF game_stats 
AS $$
DECLARE
	var_ret game_stats;
	var_curs CURSOR(min_viewer int) FOR SELECT * FROM game_stats WHERE get_game_viewer_sum(viewer_amount) >= min_viewer;
BEGIN
	--IF NOT EXISTS(SELECT * FROM pg_cursors WHERE pg_cursors.name = var_curs::NAME) THEN 
		OPEN var_curs(min_viewer := get_n_game_stats.min_viewer); 
	--END IF;
	FOR i IN 1 .. how_much LOOP
		FETCH var_curs INTO var_ret;
		RETURN NEXT var_ret;
	END LOOP;
	CLOSE var_curs;
END;
$$ 
LANGUAGE plpgsql;


SELECT * FROM get_viewer_amount_of_org(get_org_tour_by_id(120));
SELECT * FROM which_org_is_better(get_org_tour_by_id(120), get_org_tour_by_id(1200));
SELECT * FROM get_n_game_stats(5, 2500);

SELECT get_game_viewer_sum(viewer_amount) FROM get_n_game_stats(5, 2500);
SELECT get_game_viewer_sum(viewer_amount), get_game_viewer_sum_2(viewer_amount) FROM get_n_game_stats(5, 2500);

