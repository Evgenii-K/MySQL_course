USE kinopoisk;

-- Информация о фильме

DROP VIEW IF EXISTS about_film;

CREATE VIEW about_film AS
    SELECT 
        films.id AS 'Номер',
        films.originalname AS 'Название',
        films.transletionname AS 'Перевод',
        ganre.ganre_name AS 'Жанр',
        language.language_name AS 'Язык',
        films.yearcreated AS 'Год',
        GROUP_CONCAT(CONCAT(actor.first_name,
                    _utf8mb3 ' ',
                    actor.last_name)
            SEPARATOR ', ') AS 'Актеры',
		(SELECT
		        GROUP_CONCAT(CONCAT(producer.first_name,
							_utf8mb3 ' ',
							producer.last_name)
				SEPARATOR ', ') 
		 FROM people_film
			JOIN movie_people AS producer ON people_film.people = producer.id AND people_film.category = 4
		 WHERE people_film.film = films.id) AS 'Продюсер'
	FROM films
        RIGHT JOIN ganre ON films.ganre = ganre.id
        RIGHT JOIN language ON films.language = language.id
        JOIN people_film ON films.id = people_film.film
        JOIN movie_people AS actor ON people_film.people = actor.id AND people_film.category = 1
	GROUP BY films.id;
    
-- Актерско-режисерский состав

DROP VIEW IF EXISTS film_crew;

CREATE VIEW film_crew AS
	SELECT 
		films.id AS 'Номер',
		films.originalname AS 'Название Фильма',
		movie_people.last_name AS 'Фамилия',
		movie_people.first_name AS 'Имя',
		CASE
			WHEN people_film.category = 1 
				THEN 'Актёр'
			WHEN people_film.category = 2 
				THEN 'Режиссёр'
			WHEN people_film.category = 3 
				THEN 'Сценарист'
			WHEN people_film.category = 4 
				THEN 'Продюссер'
			WHEN people_film.category = 5 
				THEN 'Оператор'
			ELSE 'Композитор'
		END AS 'Профессия'
	FROM 
		people_film
	JOIN
		category ON people_film.category = category.id
	JOIN
		movie_people ON people_film.people = movie_people.id
	JOIN
		films ON people_film.film = films.id
	ORDER BY
		films.id, category, movie_people.last_name;
    
-- Рекомендованные фильмы для пользователя на основе лайков
    
DROP PROCEDURE IF EXISTS `recommendation`;

DELIMITER //

CREATE DEFINER=`root`@`localhost` PROCEDURE `recommendation`(IN nam BIGINT)
BEGIN
SELECT 
	films.id,
	films.originalname AS 'Фильм',
    films.yearcreated AS 'Год',
    ganre.ganre_name AS 'Жанр'
FROM 
	films
JOIN 
	ganre ON films.ganre = ganre.id
JOIN 
	likes ON films.id = likes.film_id
WHERE
	films .ganre = (SELECT 
		films.ganre
	 FROM 
		films
	 JOIN 
		likes ON films.id = likes.film_id
	 WHERE
		likes.user_id = nam
	 GROUP BY 
		films.ganre
	 ORDER BY 
		films.ganre DESC
	 LIMIT 1)
GROUP BY 
	films.id;
END//

DELIMITER ;

-- Изменение пользователя на анонимного в таблицах likes и comments, которые внешним ключём ссылаются на таблицу users, 
-- при удалении данных пользователя из таблицы users.

DROP TRIGGER IF EXISTS delete_profile;

DELIMITER //

CREATE TRIGGER delete_profile BEFORE DELETE ON users
FOR EACH ROW
BEGIN
	UPDATE likes SET user_id = '99' WHERE user_id = old.id;
    UPDATE comments SET user_id = '99' WHERE user_id = old.id;
END //

DELIMITER ;