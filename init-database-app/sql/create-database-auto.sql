
DROP DATABASE IF EXISTS `imdb`;
CREATE SCHEMA IF NOT EXISTS `imdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `imdb` ;

-- -----------------------------------------------------
-- Table `imdb`.`imdb_ijs_actors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `imdb`.`imdb_ijs_actors` ;

CREATE TABLE IF NOT EXISTS `imdb`.`imdb_ijs_actors` (
  `id` INT NOT NULL,
  `first_name` VARCHAR(50) NULL DEFAULT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `gender` CHAR(5) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `imdb`.`imdb_ijs_directors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `imdb`.`imdb_ijs_directors` ;

CREATE TABLE IF NOT EXISTS `imdb`.`imdb_ijs_directors` (
  `id` INT NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `first_name` (`first_name` ASC, `last_name` ASC) VISIBLE,
  INDEX `first_name_2` (`first_name` ASC) VISIBLE,
  INDEX `last_name` (`last_name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `imdb`.`imdb_ijs_directors_genres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `imdb`.`imdb_ijs_directors_genres` ;

CREATE TABLE IF NOT EXISTS `imdb`.`imdb_ijs_directors_genres` (
  `director_id` INT NULL DEFAULT NULL,
  `genre` VARCHAR(50) NULL DEFAULT NULL,
  `prob` FLOAT NULL DEFAULT NULL,
  INDEX `fk_director_id` (`director_id` ASC) VISIBLE,
  CONSTRAINT `fk_director_id`
    FOREIGN KEY (`director_id`)
    REFERENCES `imdb`.`imdb_ijs_directors` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `imdb`.`imdb_ijs_movies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `imdb`.`imdb_ijs_movies` ;

CREATE TABLE IF NOT EXISTS `imdb`.`imdb_ijs_movies` (
  `id` INT NOT NULL,
  `name` VARCHAR(50) NULL DEFAULT NULL,
  `year` INT NULL DEFAULT NULL,
  `rank` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `imdb`.`imdb_ijs_movies_directors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `imdb`.`imdb_ijs_movies_directors` ;

CREATE TABLE IF NOT EXISTS `imdb`.`imdb_ijs_movies_directors` (
  `director_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  INDEX `fk_director_id` (`director_id` ASC) VISIBLE,
  INDEX `fk_movie_id` (`movie_id` ASC) VISIBLE,
  INDEX `k_direcr_movie_id` (`director_id` ASC, `movie_id` ASC) VISIBLE,
  CONSTRAINT `fk_director_id1`
    FOREIGN KEY (`director_id`)
    REFERENCES `imdb`.`imdb_ijs_directors` (`id`),
  CONSTRAINT `fk_movie_id1`
    FOREIGN KEY (`movie_id`)
    REFERENCES `imdb`.`imdb_ijs_movies` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `imdb`.`imdb_ijs_movies_genres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `imdb`.`imdb_ijs_movies_genres` ;

CREATE TABLE IF NOT EXISTS `imdb`.`imdb_ijs_movies_genres` (
  `movie_id` INT NULL DEFAULT NULL,
  `genre` VARCHAR(50) NULL DEFAULT NULL,
  INDEX `fk_movie_id` (`movie_id` ASC) VISIBLE,
  INDEX `genre` (`genre` ASC) VISIBLE,
  CONSTRAINT `fk_movie_id2`
    FOREIGN KEY (`movie_id`)
    REFERENCES `imdb`.`imdb_ijs_movies` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `imdb`.`imdb_ijs_roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `imdb`.`imdb_ijs_roles` ;

CREATE TABLE IF NOT EXISTS `imdb`.`imdb_ijs_roles` (
  `actor_id` INT NULL DEFAULT NULL,
  `movie_id` INT NULL DEFAULT NULL,
  `role` VARCHAR(50) NULL DEFAULT NULL,
  INDEX `fk_actor_id` (`actor_id` ASC) VISIBLE,
  INDEX `fk_movie_id` (`movie_id` ASC) VISIBLE,
  CONSTRAINT `fk_actor_id`
    FOREIGN KEY (`actor_id`)
    REFERENCES `imdb`.`imdb_ijs_actors` (`id`),
  CONSTRAINT `fk_movie_id`
    FOREIGN KEY (`movie_id`)
    REFERENCES `imdb`.`imdb_ijs_movies` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `imdb` ;

-- -----------------------------------------------------
-- Placeholder table for view `imdb`.`actors_roles_movies_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `imdb`.`actors_roles_movies_view` (`actor_id` INT, `first_name` INT, `last_name` INT, `movie_id` INT);

-- -----------------------------------------------------
-- procedure filter_movie_by_director_or_genre_paginated
-- -----------------------------------------------------

USE `imdb`;
DROP procedure IF EXISTS `imdb`.`filter_movie_by_director_or_genre_paginated`;


CREATE PROCEDURE `filter_movie_by_director_or_genre_paginated`(

in seek int, 

in size int, 

in director_name varchar(50), 

in gen varchar(50))
BEGIN

with cte as (

select 

m.*,

d.first_name,

d.last_name,

concat(d.first_name,' ', d.last_name) director,

g.genre

from imdb_ijs_movies m

join imdb_ijs_movies_directors md  on m.id = md.movie_id

join imdb_ijs_directors d on d.id = md.director_id

join imdb_ijs_movies_genres g on g.movie_id = m.id



)



select 

id, 

`name`, 

`year`, 

`rank`, 

json_arrayagg(director) directors,

json_arrayagg( genre) genres

from cte

where 

(

first_name LIKE(concat('%', director_name,'%')) or

last_name LIKE(concat('%', director_name,'%'))) and

genre LIKE(concat('%', gen,'%'))



group by id, `name`, `year`, `rank`

order by m.id

limit seek, size

;

END;

-- -----------------------------------------------------
-- procedure get_actor_stats
-- -----------------------------------------------------

USE `imdb`;
DROP procedure IF EXISTS `imdb`.`get_actor_stats`;


CREATE  PROCEDURE `get_actor_stats`(in actorId int)
BEGIN

select 
a.id actor_id,
concat(first_name, ' ', last_name) `name`,
g.genre top_genre,
json_objectagg( g.genre, count(g.genre) ) over(partition by a.id) number_of_movies_by_genre,
sum( count(g.genre) ) over(partition by a.id) number_of_movies,

get_most_freq_parthner(actorId) most_frequent_partner

from imdb_ijs_actors a 
join imdb_ijs_roles r on a.id = r.actor_id
join imdb_ijs_movies m on  r.movie_id = m.id
join imdb_ijs_movies_genres g on m.id = g.movie_id

where a.id = actorId

group by 
	a.id,
	a.first_name,
	a.last_name,
	g.genre
order by count(g.genre) desc
limit 1;

END;

-- -----------------------------------------------------
-- function get_most_freq_parthner
-- -----------------------------------------------------

USE `imdb`;
DROP function IF EXISTS `imdb`.`get_most_freq_parthner`;


CREATE FUNCTION `get_most_freq_parthner`(actorId int) RETURNS json
    DETERMINISTIC
BEGIN
DECLARE extracted_json JSON;

select 
	json_object(
	'partner_actor_id', r.actor_id, 
	'partner_actor_name', concat(r.first_name, ' ', r.last_name), 
	'number_of_shared_movies', count(l.movie_id)) most_frequent_partner
into extracted_json    
from actors_roles_movies_view l 
join actors_roles_movies_view r on l.movie_id = r.movie_id and l.actor_id <> r.actor_id
where 
	l.actor_id = actorId
group by 
	l.actor_id,
	r.actor_id,
	r.first_name,
	r.last_name
order by count(l.movie_id) desc
limit 1;

RETURN extracted_json;
END;

-- -----------------------------------------------------
-- View `imdb`.`actors_roles_movies_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `imdb`.`actors_roles_movies_view`;
DROP VIEW IF EXISTS `imdb`.`actors_roles_movies_view` ;
USE `imdb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `imdb`.`actors_roles_movies_view` AS select `a`.`id` AS `actor_id`,`a`.`first_name` AS `first_name`,`a`.`last_name` AS `last_name`,`m`.`id` AS `movie_id` from ((`imdb`.`imdb_ijs_actors` `a` join `imdb`.`imdb_ijs_roles` `r` on((`a`.`id` = `r`.`actor_id`))) join `imdb`.`imdb_ijs_movies` `m` on((`r`.`movie_id` = `m`.`id`)));

