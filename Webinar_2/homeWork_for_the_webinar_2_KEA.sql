-- ДЗ 

-- Изменяем тип данных колонки hometown для добавления справочной таблицы

ALTER TABLE profiles MODIFY hometown INT UNSIGNED;

-- Справочная таблица списка стран для таблицы городов

DROP TABLE IF EXISTS country;
CREATE TABLE country (
	country_id SERIAL,
    country_name VARCHAR(100) NOT NULL UNIQUE
);

-- Справочная таблица городов для таблицы profiles
 
DROP TABLE IF EXISTS towns;
CREATE TABLE towns (
	town_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    town VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(100) NOT NULL UNIQUE,
	
    UNIQUE (town, country),
    FOREIGN KEY (country) REFERENCES country(country_name)
);

-- Добавляем внешний ключ на таблицу списка городов
  
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_hometown
FOREIGN KEY (hometown) REFERENCES towns(town_id)
ON UPDATE CASCADE
ON DELETE RESTRICT
;

-- Таблица подсчёта количества просмотров контента пользователя

DROP TABLE IF EXISTS views;
CREATE TABLE views (
	count_id SERIAL,
    media_id BIGINT UNSIGNED NOT NULL,
	view_user_id BIGINT UNSIGNED NOT NULL,
    	        
    UNIQUE (media_id, view_user_id),
	FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (view_user_id) REFERENCES users(id)
);

-- Таблица комментариев к контенту

DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
	id SERIAL,
    media_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    update_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
	FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Таблица комментариев к коментарию

DROP TABLE IF EXISTS comments_to_comments;
CREATE TABLE comments_to_comments (
	id SERIAL,
    comments_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    update_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
	FOREIGN KEY (comments_id) REFERENCES comments(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);





