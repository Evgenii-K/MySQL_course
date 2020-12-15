DROP DATABASE IF EXISTS kinopoisk;
CREATE DATABASE kinopoisk;
USE kinopoisk;

DROP TABLE IF EXISTS films;
CREATE TABLE films (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    originalname VARCHAR(50) NOT NULL COMMENT 'Название фильм',
    transletionname VARCHAR(50) COMMENT 'Перевод названия',
    language TINYINT UNSIGNED NOT NULL COMMENT 'Язык',
    yearcreated YEAR UNSIGNED NOT NULL COMMENT 'Год производства', 
 	country TINYINT UNSIGNED NOT NULL COMMENT 'Страна', 
	ganre TINYINT UNSIGNED NOT NULL COMMENT 'Жанр',
    description TEXT COMMENT 'Описание фильма',
    budget DECIMAL(10) NULL DEFAULT NULL COMMENT 'Бюджет фильма'
) COMMENT 'Таблица данных о фильмах';

DROP TABLE IF EXISTS country;
CREATE TABLE country (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(50) NOT NULL UNIQUE
) COMMENT 'Справочная таблица стран';

ALTER TABLE films ADD CONSTRAINT fk_films_country
FOREIGN KEY (country) REFERENCES country(id)
ON UPDATE CASCADE
ON DELETE RESTRICT
;

DROP TABLE IF EXISTS ganre;
CREATE TABLE ganre (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ganre_name VARCHAR(25) NOT NULL UNIQUE
) COMMENT 'Справочная таблица жанров';

ALTER TABLE films ADD CONSTRAINT fk_films_ganre
FOREIGN KEY (ganre) REFERENCES ganre(id)
ON UPDATE CASCADE
ON DELETE RESTRICT
;

DROP TABLE IF EXISTS language;
CREATE TABLE language (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    language_name CHAR(20) NOT NULL UNIQUE
) COMMENT 'Справочная таблица по языкам';

ALTER TABLE films ADD CONSTRAINT fk_films_language
FOREIGN KEY (language) REFERENCES language(id)
ON UPDATE CASCADE
ON DELETE RESTRICT
;

DROP TABLE IF EXISTS movie_people;
CREATE TABLE movie_people (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL COMMENT 'Имя',
    last_name VARCHAR(45) NOT NULL COMMENT 'Фамилия',
    gender CHAR(1) COMMENT 'Пол',
    country TINYINT UNSIGNED NOT NULL COMMENT 'Страна',
    birthday DATE COMMENT 'Дата рождения',
    biography TEXT COMMENT 'Биография' 
) COMMENT 'Таблица личностей занятых в киноиндустрии';

DROP TABLE IF EXISTS category;
CREATE TABLE category (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    profession CHAR(20) NOT NULL UNIQUE
) COMMENT 'Таблица род деятельности человека в киноиндустрии';

ALTER TABLE movie_people ADD CONSTRAINT fk_movie_people_country
FOREIGN KEY (country) REFERENCES country(id)
ON UPDATE CASCADE
ON DELETE RESTRICT
;

DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_film BIGINT UNSIGNED NOT NULL COMMENT 'id Фильма',
    description TEXT COMMENT 'Описание медиа файла',
    media_data JSON COMMENT 'Постер, трейлер и тд',
    media_type TINYINT UNSIGNED NOT NULL COMMENT 'Тип файла',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата добавления',
	update_at DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления'
) COMMENT 'Медиа файлы к фильмам';

DROP TABLE IF EXISTS media_type;
CREATE TABLE media_type (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	type CHAR(20) NOT NULL UNIQUE
) COMMENT 'Справочная таблица типов медиа файлов';

ALTER TABLE media ADD CONSTRAINT fk_media_type
FOREIGN KEY (media_type) REFERENCES media_type(id)
ON UPDATE CASCADE
ON DELETE RESTRICT
;

DROP TABLE IF EXISTS media_film;
CREATE TABLE media_film (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_film BIGINT UNSIGNED NOT NULL,
	id_media BIGINT UNSIGNED NOT NULL,
    
	FOREIGN KEY (id_film) REFERENCES films(id),
    FOREIGN KEY (id_media) REFERENCES media(id)
) COMMENT 'Таблица соответсвия Фильм - Медиа файлы';

DROP TABLE IF EXISTS people_film;
CREATE TABLE people_film (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    film BIGINT UNSIGNED NOT NULL,
	people BIGINT UNSIGNED NOT NULL,
    category TINYINT UNSIGNED NOT NULL,
    
	FOREIGN KEY (film) REFERENCES films(id),
    FOREIGN KEY (people) REFERENCES movie_people(id),
    FOREIGN KEY (category) REFERENCES category(id)
) COMMENT 'Таблица соответсвия Люди - Фильмы - Род деятельности';

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(50) NOT NULL UNIQUE,
    country TINYINT UNSIGNED NOT NULL,
	
    UNIQUE (city, country),
    FOREIGN KEY (country) REFERENCES country(id)
) COMMENT 'Справочная таблица городов';

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(50) UNIQUE,
    phone BIGINT UNSIGNED UNIQUE, 
    city INT UNSIGNED,
    
    INDEX id_users_firstname_lastname (firstname, lastname),
    FOREIGN KEY (city) REFERENCES cities(id)
) COMMENT 'Данные пользователей сайта';

DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
	id SERIAL,
    film_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    update_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
	FOREIGN KEY (film_id) REFERENCES films(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT 'Коментарии к фильмам от пользователей';

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    film_id BIGINT UNSIGNED NOT NULL,
    
    PRIMARY KEY (user_id, film_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (film_id) REFERENCES films(id)
) COMMENT 'Лайки к фильмам пользователей';

