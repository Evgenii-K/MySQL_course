DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(50) UNIQUE,
    phone BIGINT UNSIGNED UNIQUE, 
    
    INDEX idx_users_firstname_lastname (firstname, lastname)
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    gender char(1),
    hometown VARCHAR(100),
    created_at DATETIME DEFAULT NOW()
 );
 
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id
FOREIGN KEY (user_id) REFERENCES users(id)
ON UPDATE CASCADE
ON DELETE RESTRICT
;
 
ALTER TABLE profiles ADD COLUMN birthday DATE;

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL,
    from_user_id BIGINT UNSIGNED,
    to_user_id BIGINT UNSIGNED,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
    status ENUM ('request', 'approved', 'unfriended', 'declined'),
    created_at DATETIME DEFAULT NOW(),
    update_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (initiator_user_id, target_user_id),
	FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id),
    CHECK (initiator_user_id != target_user_id)
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
	id SERIAL,
    name VARCHAR(255),
    admin_user_id BIGINT UNSIGNED NOT NULL,
        
    INDEX (name),
    FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities (
    community_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	        
    PRIMARY KEY (community_id, user_id),
	FOREIGN KEY (community_id) REFERENCES communities(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS media_type;
CREATE TABLE media_type (
	id SERIAL,
    name VARCHAR(255)
);

DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    filename VARCHAR(255),
    metadata JSON,
	media_type_id BIGINT UNSIGNED NOT NULL,
    
	created_at DATETIME DEFAULT NOW(),
    update_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_type(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    
    PRIMARY KEY (user_id, media_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);



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





