use imdb;


LOAD DATA LOCAL INFILE '{path}/imdb_ijs_movies.csv' IGNORE
INTO TABLE imdb_ijs_movies
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE '{path}/imdb_ijs_actors.csv' IGNORE
INTO TABLE imdb_ijs_actors
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '{path}/imdb_ijs_directors.csv' IGNORE
INTO TABLE imdb_ijs_directors
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '{path}/imdb_ijs_directors_genres.csv' IGNORE
INTO TABLE imdb_ijs_directors_genres
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '{path}/imdb_ijs_movies_directors.csv' IGNORE
INTO TABLE imdb_ijs_movies_directors
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '{path}/imdb_ijs_movies_genres.csv' IGNORE
INTO TABLE imdb_ijs_movies_genres
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '{path}/imdb_ijs_roles.csv' IGNORE
INTO TABLE imdb_ijs_roles
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
IGNORE 1 ROWS;


