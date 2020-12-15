use kinopoisk;

-- Информация о фильме

select * from about_film;

-- Актерско-режисерский состав

select * from film_crew;

-- Рекомендованные фильмы для пользователя на основе лайков

call recommendation(1);

-- Выборка фильнов в которых человек принимал участие как актёр

SELECT 
	films.originalname AS 'Фильм',
    films.yearcreated AS 'Год',
    ganre.ganre_name AS 'Жанр'
FROM 
	films
JOIN 
	ganre ON films.ganre = ganre.id
JOIN 
	people_film ON films.id = people_film.film
WHERE
    people_film.category = 1 and people_film.people = 1
ORDER BY 
	films.yearcreated DESC;

-- Новинки

SELECT 
	films.originalname AS 'Название',
    films.transletionname AS 'Перевод',
	language.language_name AS 'Язык',
    ganre.ganre_name AS 'Жанр',
    country.country_name AS 'Страна',
	IFNULL(films.budget, '') AS 'Бюджет',
    films.description AS 'Описание'    
FROM 
	films
JOIN 
	ganre ON films.ganre = ganre.id
JOIN 
	language ON films.language = language.id
JOIN 
	country ON films.country = country.id
WHERE
    films.yearcreated = YEAR(CURDATE())
ORDER BY
	films.originalname;
    
-- Рейтинг фильмов на основе лайков потльзователей

SELECT 
	films.id AS 'Номер',
	films.originalname AS 'Фильм',
    films.yearcreated AS 'Год',
    ganre.ganre_name AS 'Жанр',
    (select 
		COUNT(*)
	 from
		likes
	 where
		film_id = films.id) as 'Рейтинг'
FROM 
	films
JOIN 
	ganre ON films.ganre = ganre.id
JOIN 
	likes ON films.id = likes.film_id
group by
	films.id
order by
	Рейтинг DESC;