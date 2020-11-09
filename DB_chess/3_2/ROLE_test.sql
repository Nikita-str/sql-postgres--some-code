REVOKE ALL ON game_stats FROM test;
REVOKE ALL ON tour_stats FROM test;
REVOKE ALL ON player_stats FROM test;
DROP ROLE IF EXISTS test;
CREATE USER test WITH PASSWORD '1';

GRANT SELECT ON game_stats TO test;

GRANT SELECT, UPDATE, INSERT ON tour_stats TO test;
REVOKE UPDATE(tour_id) ON tour_stats FROM test; -- we dont wanna upd id

GRANT SELECT(player_stats_id, rating_date, rating), UPDATE(rating_date, rating) ON player_stats TO test;

--GRANT SELECT UPDATE ON  TO test;
